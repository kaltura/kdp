package com.kaltura.kdpfl.view
{
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.AdOpportunityType;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.SequenceContextType;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	import com.kaltura.osmf.proxy.KSwitchingProxyElement;
	import com.kaltura.types.KalturaAdType;
	import com.kaltura.types.KalturaCuePointType;
	import com.kaltura.utils.ObjectUtil;
	import com.kaltura.vo.KalturaAdCuePoint;
	import com.kaltura.vo.KalturaAnnotation;
	import com.kaltura.vo.KalturaCodeCuePoint;
	import com.kaltura.vo.KalturaCuePoint;
	
	import org.osmf.events.TimelineMetadataEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaPlayer;
	import org.osmf.metadata.TimelineMarker;
	import org.osmf.metadata.TimelineMetadata;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * New Mediator for the cue point data of the KDP 
	 * @author Hila
	 * 
	 */	
	public class CuePointsMediator extends Mediator
	{
		public static const NAME : String = "cuePointsMediator";
		
		/**
		 * The instance of the KDP's OSMF MediaPlayer.
		 */		
		private var _mediaPlayerInst : MediaPlayer;
		/**
		 * The current media element.
		 */		
		private var _media : MediaElement;
		
		/**
		 * duration of current entry in milliseconds
		 * */
		private var _entryDurationInMS:Number;
		/**
		 * The map of the current entry's cue-points.
		 */		
		private var _cuePointsMap : Object = new Object();
		/**
		 * The map of the current entry's cue-points per this play session
		 */		
		private var _sessionCuePointsMap : Object = new Object();
		/**
		 * The KDP flashvars.
		 */		
		private var _flashvars : Object;
		/**
		 * The timeline metadata object related to the current main media.
		 */		
		private var _timelineMetadata : TimelineMetadata;
		/**
		 * Flag which disables ads in case the media has already played through to its end once.
		 */		
		private var _reachedMediaEnd : Boolean = false;
		
		/**
		 * if true, midroll sequence won't start on cue point reached 
		 */		
		private var _disableCuePointsMidroll:Boolean = false;
		/**
		 * offset to subtract from cuePoint's start time (in case of mp4 intelli seek)
		 */		
		private var _intimeOffset:Number = 0;
	
		public function CuePointsMediator(proxyName:String=null, data:Object=null)
		{
			super(NAME);
		}
		
		override public function listNotificationInterests():Array
		{
			var returnArr : Array = [NotificationType.LAYOUT_READY, 
									NotificationType.ENTRY_READY,
									NotificationType.MEDIA_LOADED,
									NotificationType.CUE_POINTS_RECEIVED,
									NotificationType.PLAYER_PLAY_END,
									NotificationType.CHANGE_MEDIA,
									NotificationType.RE_REGISTER_CUE_POINTS];
			return returnArr;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var sequenceProxy : SequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
			//in case we play bumper - ignore the notifications
			if (sequenceProxy.vo.isInSequence)
			{
				return;
			}
			switch (notification.getName() )
			{
				case NotificationType.LAYOUT_READY:
					_mediaPlayerInst = (facade.retrieveMediator( KMediaPlayerMediator.NAME ) as KMediaPlayerMediator).player;
					_flashvars = (facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy).vo.flashvars;
					if (_flashvars.disableCuePointsMidroll && _flashvars.disableCuePointsMidroll == "true")
						_disableCuePointsMidroll = true;
					addListeners ();
					break;
				
				case NotificationType.ENTRY_READY:
					_entryDurationInMS = (facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy).vo.entry.msDuration;
					break;
				
				case NotificationType.CUE_POINTS_RECEIVED:
					//don't change the notification.body, copy the object
					ObjectUtil.copyObject(notification.getBody(), _cuePointsMap);
					findPrePostSequence();
					_sessionCuePointsMap = new Object();
					ObjectUtil.copyObject(_cuePointsMap, _sessionCuePointsMap);					
					break;
				
				case NotificationType.MEDIA_LOADED:
					_media = (facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy).vo.media;
					_reachedMediaEnd = false;
					initTimelineMarkers ();
					break;
				
				case NotificationType.PLAYER_PLAY_END:
					//in order to display midrolls again, reset _sessionCuePointMap
					if (_flashvars.adsOnReplay && _flashvars.adsOnReplay=="true")
					{
						_reachedMediaEnd = false;
						ObjectUtil.copyObject(_cuePointsMap, _sessionCuePointsMap);	
					}
					else
					{
						_reachedMediaEnd = true;
					}
					break;
				
				case NotificationType.CHANGE_MEDIA:
					// reset entry's cuepoints map, so we won't accumulate cuepoints 
					// (i.e., between entries in playlist)
					_cuePointsMap = new Object();
					break;
				case NotificationType.RE_REGISTER_CUE_POINTS:
					initTimelineMarkers(Number(notification.getBody().offsetAddition));
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
		/**
		 *  Handler for the <code>TimeLineMarkerEvent</code> fired when a TimelineMarker is reached
		 * during the playhead progress.
		 * @param e
		 * 
		 */		
		protected function onCuePointReached ( e : TimelineMetadataEvent ) : void
		{
			var startTime : Number =  e.marker.time;
			var startTimeInMS:Number = (startTime + _intimeOffset) * 1000;
			
			var shouldStartMidrollSequence : Boolean = false;
			for each (var cuePoint : KalturaCuePoint in _sessionCuePointsMap[startTimeInMS])
			{
				if ((cuePoint.type == KalturaCuePointType.AD || cuePoint is KalturaAdCuePoint) && !_reachedMediaEnd)
				{
					if (!_disableCuePointsMidroll)
					{
						sendNotification( NotificationType.AD_OPPORTUNITY , {context : SequenceContextType.MID, cuePoint : cuePoint, type: AdOpportunityType.CUE_POINT} );
					}
					
					if ( ((cuePoint as KalturaAdCuePoint).adType == KalturaAdType.VIDEO) || ((cuePoint as KalturaAdCuePoint).forceStop > 0 ))
					{
						shouldStartMidrollSequence = true;
					}
				}
				else if (cuePoint.type == KalturaCuePointType.CODE || cuePoint is KalturaCodeCuePoint || cuePoint is KalturaAnnotation)
				{
					sendNotification( NotificationType.CUE_POINT_REACHED , { cuePoint : cuePoint} );
				}
			}
			
			if (!_disableCuePointsMidroll && shouldStartMidrollSequence)
			{
				var sequenceProxy : SequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
				sequenceProxy.startMidSequence(false);;
			}
			
			delete (_sessionCuePointsMap[startTimeInMS]);
			
		}
		/**
		 * This function creates a TimelineMetadata object for the main media of the player.
		 * The timeline markers of this object are positioned on the cue points' start-times.
		 * 
		 */		
		protected function initTimelineMarkers (offset:Number = 0) : void
		{
			if (_timelineMetadata)
				_timelineMetadata.removeEventListener( TimelineMetadataEvent.MARKER_TIME_REACHED, onCuePointReached );
			
			_intimeOffset = offset;
			
			if ((_media as KSwitchingProxyElement).mainMediaElement)
			{
				_timelineMetadata = new TimelineMetadata((_media as KSwitchingProxyElement).mainMediaElement);
				_timelineMetadata.addEventListener( TimelineMetadataEvent.MARKER_TIME_REACHED , onCuePointReached);
				for (var startTime : String in _cuePointsMap)
				{
					//if we performed mp4 intelli-seek, we need to add offset to cuePoints
					var inTime:Number = (Number(startTime)/1000 - offset);
					if (inTime >= 0) 
					{
						_timelineMetadata.addMarker( new TimelineMarker(inTime) );	
					}
					
				}
			}
			
			sendNotification( NotificationType.CUE_POINTS_REGISTERED );
		}
		
		/**
		 * Adds the kalturaCuePoints from the given array to the KDP cue points 
		 * should be called before MEDIA_LOADED
		 * @param cpArray array of KalturaCuePoint
		 * 
		 */		
		public function addCuePoints(cpArray:Array):void {
			var sequenceProxy : SequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
			
			for (var i:int = 0; i<cpArray.length; i++) {
				var cp:KalturaCuePoint = cpArray[i] as KalturaCuePoint;
				if (!cp)
					return;
				
				//preroll & postroll
				if (cp.startTime==0 || cp.startTime==_entryDurationInMS) {
					if (cp.type == KalturaCuePointType.AD || cp is KalturaAdCuePoint)
					{
						sendNotification( NotificationType.AD_OPPORTUNITY ,{context : (cp.startTime==0) ? SequenceContextType.PRE : SequenceContextType.POST, cuePoint : cp, type: AdOpportunityType.CUE_POINT} );	
					}
					else 
					{
						addToCPMap(cp);
					}
				}		
				else 
				{
					addToCPMap(cp);
				}		
			}
			sequenceProxy.initPreIndex();
		//	sequenceProxy.initPostIndex();
		}
		
		private function addToCPMap(cp:KalturaCuePoint):void {
			if (_cuePointsMap[cp.startTime])
				_cuePointsMap[cp.startTime].push(cp);
			else {
				_cuePointsMap[cp.startTime] = new Array(cp);
			}
		}
		
		
		/**
		 * This function separates ad cue points configured with a start time equal to 0 or the entry's duration,
		 * and adds the plugins associated with these cue points to the pre/post arrays. 
		 * 
		 */		
		protected function findPrePostSequence () : void
		{
			var sequenceProxy : SequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
			//entry ready notification is sent later, so we cant use _entryDurationInMS
			var entryDurationInMS:Number = (facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.entry.msDuration;
			
			var prerollAdCuePoints : Array = new Array();
			
			var postrollAdCuePoints : Array = new Array();
			
			if (_cuePointsMap[0] && _cuePointsMap[0].length)
			{
				prerollAdCuePoints =  (_cuePointsMap[0] as Array).filter( isAdCuePoint );
				_cuePointsMap[0]  =  (_cuePointsMap[0] as Array).filter( isNotAdCuePoint );
			}
			
			if (_cuePointsMap[entryDurationInMS] && _cuePointsMap[entryDurationInMS].length)
			{
				postrollAdCuePoints = (_cuePointsMap[entryDurationInMS] as Array).filter( isAdCuePoint );
				_cuePointsMap[entryDurationInMS] = (_cuePointsMap[entryDurationInMS] as Array).filter( isNotAdCuePoint );
			}
			
			if ( prerollAdCuePoints && prerollAdCuePoints.length )
			{
				while ( prerollAdCuePoints.length )
				{
					var preCuePoint : KalturaCuePoint = prerollAdCuePoints[0];
					if (preCuePoint.type == KalturaCuePointType.AD || preCuePoint is KalturaAdCuePoint)
					{
						sendNotification( NotificationType.AD_OPPORTUNITY ,{context : SequenceContextType.PRE, cuePoint : preCuePoint, type: AdOpportunityType.CUE_POINT} );
						prerollAdCuePoints.shift();
						
					}
				}
				
				sequenceProxy.initPreIndex();
			}
			if ( postrollAdCuePoints && postrollAdCuePoints.length)
			{
				while ( postrollAdCuePoints.length )
				{
					var postCuePoint : KalturaCuePoint = postrollAdCuePoints[0];
					if (postCuePoint.type == KalturaCuePointType.AD || postCuePoint is KalturaAdCuePoint)
					{
						sendNotification( NotificationType.AD_OPPORTUNITY ,{context : SequenceContextType.POST, cuePoint : postCuePoint, type: AdOpportunityType.CUE_POINT} );
						postrollAdCuePoints.shift();
					}
				}
				//sequenceProxy.initPostIndex();
			}
			
		}
		
		protected function isAdCuePoint (cuePoint : Object , index : int , array : Array) : Boolean
		{
			if (cuePoint is KalturaAdCuePoint)
				return true;
			return false;
		}
		
		protected function isNotAdCuePoint (cuePoint : Object , index : int , array : Array) : Boolean
		{
			if (!(cuePoint is KalturaAdCuePoint))
				return true;
			return false;
		}
	}
}