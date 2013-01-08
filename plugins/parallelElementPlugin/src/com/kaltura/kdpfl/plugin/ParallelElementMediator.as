package com.kaltura.kdpfl.plugin
{
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.StreamerType;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	import com.kaltura.vo.KalturaLiveStreamEntry;
	
	import org.osmf.elements.ParallelElement;
	import org.osmf.events.MediaElementEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.AudioTrait;
	import org.osmf.traits.DisplayObjectTrait;
	import org.osmf.traits.MediaTraitType;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ParallelElementMediator extends Mediator
	{
		public static const NAME:String = "parallelElementMediator";
		private var _mediaProxy:MediaProxy;
		
		public function ParallelElementMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			_mediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
		}
		
		override public function listNotificationInterests():Array
		{
			return [NotificationType.CREATE_PARALLEL_ELEMENT, NotificationType.RESTORE_MAIN_PARALLEL_ELEMENT, NotificationType.KDP_EMPTY, NotificationType.ENTRY_READY];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationType.CREATE_PARALLEL_ELEMENT:
					//create parallelElement and save it as the player's media.
					var parallel:ParallelElement = new ParallelElement();
					var mainMedia:MediaElement = _mediaProxy.vo.media;
					var prerollMedia:MediaElement = notification.getBody().mediaElement;
					
					mainMedia.addEventListener(MediaElementEvent.TRAIT_ADD, onAudioAdd);
					
					parallel.addChild(mainMedia);
					parallel.addChild(prerollMedia);
					(facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator).player.media = parallel;
					_mediaProxy.vo.media  = parallel;
					(facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy).saveMainMedia();
					break;
				
				case NotificationType.RESTORE_MAIN_PARALLEL_ELEMENT:
					//restore main media when the element is parallel element
					var parallelMedia:ParallelElement = (facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator).player.media as ParallelElement;
					//remove the preroll element
					if (parallelMedia.numChildren > 1) {
						parallelMedia.removeChildAt(1);
					}				
					//restore live stream
					var mainMediaElement:MediaElement = parallelMedia.getChildAt(0) as MediaElement;				
					var audioTrait:AudioTrait = mainMediaElement.getTrait(MediaTraitType.AUDIO) as AudioTrait;
					audioTrait.muted = false;
					break;
				
				case NotificationType.KDP_EMPTY:
					if (_mediaProxy.vo.deliveryType == StreamerType.LIVE)
					{
						_mediaProxy.vo.useParallelElement = true;
					}
					break;
				
				case NotificationType.ENTRY_READY:
					if (_mediaProxy.vo.entry is KalturaLiveStreamEntry || _mediaProxy.vo.deliveryType == StreamerType.LIVE)
					{
						_mediaProxy.vo.useParallelElement = true;
					}
					else
					{
						_mediaProxy.vo.useParallelElement = false;
					}
					break;
			}
		}
		
		
		
		/**
		 * for parallel elements: media audio trait was added, mute it during preroll play
		 * @param e
		 * 
		 */		
		private function onAudioAdd(e:MediaElementEvent):void 
		{
			if (e.traitType == MediaTraitType.AUDIO) 
			{		
				var audioTrait:AudioTrait = e.target.getTrait(MediaTraitType.AUDIO) as AudioTrait;
				audioTrait.muted = true;
				e.target.removeEventListener(MediaElementEvent.TRAIT_ADD, onAudioAdd);
			}
			
		}
		
	}
}