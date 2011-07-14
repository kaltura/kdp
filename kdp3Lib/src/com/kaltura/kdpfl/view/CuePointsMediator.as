package com.kaltura.kdpfl.view
{
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.CuePointType;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.SequenceContextType;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	import com.kaltura.osmf.proxy.KSwitchingProxyElement;
	import com.kaltura.types.KalturaAdType;
	import com.kaltura.types.KalturaCuePointType;
	import com.kaltura.vo.KalturaAdCuePoint;
	import com.kaltura.vo.KalturaCuePoint;
	
	import org.osmf.events.TimelineMetadataEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaPlayer;
	import org.osmf.metadata.TimelineMarker;
	import org.osmf.metadata.TimelineMetadata;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class CuePointsMediator extends Mediator
	{
		public static const NAME : String = "cuePointsMediator";
		
		private var _mediaPlayerInst : MediaPlayer;
		
		private var _media : MediaElement;
		
		private var _entryDuration : Number;
		
		private var _cuePointsMap : Object = new Object();
		
		private var _flashvars : Object;
		
		private var _timelineMetadata : TimelineMetadata;
		
		private var _reachedMediaEnd : Boolean = false;
		
		public function CuePointsMediator(proxyName:String=null, data:Object=null)
		{
			super(NAME);
		}
		
		override public function listNotificationInterests():Array
		{
			var returnArr : Array = [NotificationType.LAYOUT_READY, NotificationType.ENTRY_READY, 
				NotificationType.MEDIA_READY,NotificationType.CUE_POINTS_RECEIVED,NotificationType.PLAYER_PLAY_END];
			return returnArr;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName() )
			{
				case NotificationType.LAYOUT_READY:
					_mediaPlayerInst = (facade.retrieveMediator( KMediaPlayerMediator.NAME ) as KMediaPlayerMediator).player;
					_flashvars = (facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy).vo.flashvars;
					addListeners ();
					break;
				
				case NotificationType.ENTRY_READY:

					_entryDuration = (facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy).vo.entry.duration;
					
					break;
				case NotificationType.CUE_POINTS_RECEIVED:
					
					_cuePointsMap = notification.getBody();
					
					
					break;
				case NotificationType.MEDIA_READY:
					_media = (facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy).vo.media;
					_reachedMediaEnd = false;
					initTimelineMarkers ();
					break;
				
				case NotificationType.PLAYER_PLAY_END:
					//_timelineMetadata.removeEventListener( TimelineMetadataEvent.MARKER_TIME_REACHED, onCuePointReached );
					_reachedMediaEnd = true;
					break;
			}
		}
		
		protected function addListeners () : void
		{
			if (_mediaPlayerInst)
			{
				_mediaPlayerInst.addEventListener( TimelineMetadataEvent.MARKER_TIME_REACHED , onCuePointReached);
			}
		}
		
		protected function onCuePointReached ( e : TimelineMetadataEvent ) : void
		{
			var startTime : Number =  e.marker.time;
			
			var shouldStartMidrollSequence : Boolean = false;
			
			for each (var cuePoint : KalturaCuePoint in _cuePointsMap[startTime])
			{
				if ((cuePoint.type == KalturaCuePointType.AD || cuePoint is KalturaAdCuePoint) && !_reachedMediaEnd)
				{
					sendNotification( NotificationType.AD_OPPORTUNITY , {context : SequenceContextType.MID, cuePoint : cuePoint} );
					
					if ( ((cuePoint as KalturaAdCuePoint).adType == KalturaAdType.VIDEO) || ((cuePoint as KalturaAdCuePoint).forceStop > 0 ))
					{
						shouldStartMidrollSequence = true;
					}
				}
				else if (cuePoint.type == KalturaCuePointType.CODE)
				{
					sendNotification( NotificationType.CUE_POINT_REACHED , { cuePoint : cuePoint} );
				}
			}
			
			if (shouldStartMidrollSequence)
			{
				var sequenceProxy : SequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
				
				sequenceProxy.vo.midCurrentIndex = 0;
				
				sendNotification(NotificationType.DO_PAUSE );
				
				sequenceProxy.playNextInSequence();
			}
			
		}
		
		protected function initTimelineMarkers () : void
		{
			findPrePostSequence();
			
			if ((_media as KSwitchingProxyElement).mainMediaElement)
			{
				_timelineMetadata = new TimelineMetadata((_media as KSwitchingProxyElement).mainMediaElement);
				_timelineMetadata.addEventListener( TimelineMetadataEvent.MARKER_TIME_REACHED , onCuePointReached);
				for (var startTime : String in _cuePointsMap)
				{
					_timelineMetadata.addMarker( new TimelineMarker(Number(startTime)) );
					
				}
			}
			
			sendNotification( NotificationType.CUE_POINTS_REGISTERED );
		}
		
		protected function findPrePostSequence () : void
		{
			var sequenceProxy : SequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
			if ( _cuePointsMap[0] && _cuePointsMap[0].length )
			{
				while ( (_cuePointsMap[0] as Array).length )
				{
					var preCuePoint : KalturaCuePoint = _cuePointsMap[0][0];
					if (preCuePoint.type == KalturaCuePointType.AD || preCuePoint is KalturaAdCuePoint)
					{
						sendNotification( NotificationType.AD_OPPORTUNITY ,{context : SequenceContextType.PRE, cuePoint : preCuePoint} );
						(_cuePointsMap[0] as Array).shift();
						
					}
				}
				
				sequenceProxy.initPreIndex();
			}
			if ( _cuePointsMap[_entryDuration] && _cuePointsMap[_entryDuration].length)
			{
				while ( (_cuePointsMap[_entryDuration] as Array).length )
				{
					var postCuePoint : KalturaCuePoint = _cuePointsMap[_entryDuration][0];
					if (postCuePoint.type == KalturaCuePointType.AD || postCuePoint is KalturaAdCuePoint)
					{
						sendNotification( NotificationType.AD_OPPORTUNITY ,{context : SequenceContextType.POST, cuePoint : postCuePoint} );
						(_cuePointsMap[_entryDuration] as Array).shift();
					}
				}
				sequenceProxy.initPostIndex();
			}
			
		}
	}
}