package com.kaltura.kdpfl.plugin
{
	import com.akamai.osmf.elements.AkamaiVideoElement;
	import com.akamai.osmf.utils.AkamaiStrings;
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	import org.osmf.media.MediaElement;
	import org.osmf.elements.ProxyElement;
	
	import org.osmf.events.MediaElementEvent;
	import org.osmf.traits.DVRTrait;
	import org.osmf.traits.MediaTraitType;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class akamaiHDMediator extends Mediator
	{
		
		public static const NAME:String = "akamaiHDMediator";
		/**
		 * default buffer length to be used when playing with HD Akamai plugin 
		 */		
		public static const DEFAULT_HD_BUFFER_LENGTH:int = 20;
		
		/**
		 * default bandwith check time in seconds
		 */		
		public static const DEFAULT_HD_BANDWIDTH_CHECK_TIME:int = 2;	
		
		private var _mediaProxy:MediaProxy;
		private var _flashvars:Object;
		
		public function akamaiHDMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			_mediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
			_flashvars = (facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy).vo.flashvars;
			super.onRegister();
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationType.MEDIA_READY,
				NotificationType.PLAYER_PLAYED,
				NotificationType.MEDIA_ELEMENT_READY
			];
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationType.PLAYER_PLAYED:
					//workaround to display the bitrate that was automatically detected by akamai
					if (_flashvars.hdnetworkEnableBRDetection && _flashvars.hdnetworkEnableBRDetection=="true")
					{
						_mediaProxy.notifyStartingIndexChanged((facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator).player.currentDynamicStreamIndex);
					}
					break;
				
				case NotificationType.MEDIA_READY:
					//add akamai metadata on the stream resource 

					//find last index of resource metadata flashvars. 
					var i:int = 0;
					while (_flashvars.hasOwnProperty("objMetadataNamespace" + i) && _flashvars.hasOwnProperty("objMetadataValues" + i))
					{	
						i++;
					}
					
					var bufferLength:int = DEFAULT_HD_BUFFER_LENGTH;
					if (_flashvars.hdnetworkBufferLength && _flashvars.hdnetworkBufferLength!="")
					{
						bufferLength = _flashvars.hdnetworkBufferLength;
					}
					
					//Then add akamai resource metadata on the next index
					_flashvars["objMetadataNamespace"+i] = AkamaiStrings.AKAMAI_ADVANCED_STREAMING_PLUGIN_METADATA_NAMESPACE;
					//set buffer length
					var akamaiMetadataValues:String = AkamaiStrings.AKAMAI_METADATA_KEY_MAX_BUFFER_LENGTH + "=" + bufferLength;
					//disable netsession mode
					akamaiMetadataValues +="&" + AkamaiStrings.AKAMAI_METADATA_KEY_USE_NETSESSION + "=never";
					
					if (_flashvars.hdnetworkEnableBRDetection && _flashvars.hdnetworkEnableBRDetection=="true")
					{
						//var bwEstimationObject:Object = new Object();
						//bwEstimationObject.enabled = true;
						var bandwidthEstimationPeriodInSeconds:int;
						if (_flashvars.hdnetworkBRDetectionTime && _flashvars.hdnetworkBRDetectionTime!="")
						{
							bandwidthEstimationPeriodInSeconds = _flashvars.hdnetworkBRDetectionTime; 		
						}
						else
						{
							bandwidthEstimationPeriodInSeconds = DEFAULT_HD_BANDWIDTH_CHECK_TIME;
						}
						//enable akamai BW detection
						akamaiMetadataValues += "&"+ AkamaiStrings.AKAMAI_METADATA_KEY_SET_BANDWIDTH_ESTIMATION_ENABLED + "={enabled:true,bandwidthEstimationPeriodInSeconds:"+bandwidthEstimationPeriodInSeconds+"}";
					}
					else
					{
						var preferedIndex:int = _mediaProxy.getFlavorByBitrate(_mediaProxy.vo.preferedFlavorBR);
						if (preferedIndex!=-1) 
						{
							akamaiMetadataValues += "&" + AkamaiStrings.AKAMAI_METADATA_KEY_MBR_STARTING_INDEX + "=" + preferedIndex;
							_mediaProxy.notifyStartingIndexChanged(preferedIndex);
						}
					}
					
					_flashvars["objMetadataValues"+i] = akamaiMetadataValues;
					break;
				
				case NotificationType.MEDIA_ELEMENT_READY:
					if (_mediaProxy.vo.isLive && _mediaProxy.vo.canSeek && _mediaProxy.vo.media)
					{
						_mediaProxy.vo.media.addEventListener(MediaElementEvent.TRAIT_ADD, onMediaTraitAdd);
						
					}
					//get embedded text, if exists
					var media : MediaElement = _mediaProxy.vo.media;
					while (media is ProxyElement)
					{
						media = (media as ProxyElement).proxiedElement;
					} 
					if (media is AkamaiVideoElement) {
						(media as AkamaiVideoElement).client.addHandler( "onTextData", onEmbeddedCaptions );
					}
			}
		}
		
		private function onEmbeddedCaptions (info: Object)  : void {
			sendNotification("loadEmbeddedCaptions", info);
		}
		
		
		/**
		 * sets DVR window size according to actual window size (including Akamai's padding)
		 * @param e
		 * 
		 */		
		private function onMediaTraitAdd(e: MediaElementEvent) :  void
		{
			if (e.traitType==MediaTraitType.DVR)
			{
				var dvrTrait:DVRTrait = _mediaProxy.vo.media.getTrait(MediaTraitType.DVR) as DVRTrait;
				(facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator).dvrWinSize = dvrTrait.windowDuration;
				_mediaProxy.vo.media.removeEventListener(MediaElementEvent.TRAIT_ADD, onMediaTraitAdd);
			}
			
		}
		
	}
}