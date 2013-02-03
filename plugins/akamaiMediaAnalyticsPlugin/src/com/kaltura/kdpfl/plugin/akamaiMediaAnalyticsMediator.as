package com.kaltura.kdpfl.plugin
{
	import com.akamai.playeranalytics.AnalyticsPluginLoader;
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.PlayerStatusProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.StreamerType;
	import com.kaltura.types.KalturaMediaType;
	import com.kaltura.vo.KalturaBaseEntry;
	import com.kaltura.vo.KalturaFlavorAsset;
	import com.kaltura.vo.KalturaMediaEntry;
	
	import flash.system.Capabilities;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class akamaiMediaAnalyticsMediator extends Mediator
	{
		public static const NAME:String = "akamaiMediaAnalyticsMediator";
		private var _mediaProxy:MediaProxy;
	//	private var _hadBWCheck:Boolean = false;
		
		public function akamaiMediaAnalyticsMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			_mediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
			super.onRegister();
		}
		
		override public function listNotificationInterests():Array
		{
			return [NotificationType.MEDIA_READY, NotificationType.MEDIA_ELEMENT_READY, NotificationType.CHANGE_PREFERRED_BITRATE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationType.MEDIA_READY:
					//populate analytics metadata
					var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
					var entry:KalturaBaseEntry = _mediaProxy.vo.entry;			
					
					AnalyticsPluginLoader.setData("publisherId", configProxy.vo.flashvars.partnerId);
					AnalyticsPluginLoader.setData("playerVersion", facade["kdpVersion"]);
					AnalyticsPluginLoader.setData("playerId", configProxy.vo.kuiConf.id);
					AnalyticsPluginLoader.setData("device", Capabilities.os );
					AnalyticsPluginLoader.setData("playerLoadtime",(facade.retrieveProxy(PlayerStatusProxy.NAME) as PlayerStatusProxy).vo.loadTime);
					
					
					if (entry is KalturaMediaEntry)
					{
						AnalyticsPluginLoader.setData("title", entry.id);
						
						var mediaEntry:KalturaMediaEntry = entry as KalturaMediaEntry;
						AnalyticsPluginLoader.setData("contentLength", mediaEntry.msDuration);
						
						//find content type
						var contentType:String;
						switch (mediaEntry.mediaType)
						{
							case KalturaMediaType.VIDEO:
								contentType = "video";
								break;
							case KalturaMediaType.AUDIO:
								contentType = "audio";
								break;
							case KalturaMediaType.IMAGE:
								contentType = "image";
								break;
							default:
								contentType = "live";
						}
						AnalyticsPluginLoader.setData("category", contentType);
					}
				
					break;
				
				case NotificationType.MEDIA_ELEMENT_READY:
					//find starting flavor ID
					var flavorAssetId:String;
					var flavorParamsId:String;
					if (_mediaProxy.vo.deliveryType == StreamerType.HTTP)
					{
						flavorAssetId = _mediaProxy.vo.selectedFlavorId;						
					}
					else
					{	
						flavorAssetId = getFlavorIdByIndex(_mediaProxy.startingIndex);
					}
					
					for each (var kfa:KalturaFlavorAsset in _mediaProxy.vo.kalturaMediaFlavorArray) {
						if (kfa.id == flavorAssetId) {
							flavorParamsId = kfa.flavorParamsId.toString();
							break;
						}
					}
					
					if (flavorParamsId)
						AnalyticsPluginLoader.setData("flavorId", flavorParamsId);
					
					break;
				
				case NotificationType.CHANGE_PREFERRED_BITRATE:
					//TODO: add indication we performed BW check
					//_hadBWCheck = true;
					break;
			}
		}
		
		/**
		 * returns the id of the flavor asset in the given index. null if index is invalid. 
		 * @param index
		 * @return 
		 * 
		 */		
		private function getFlavorIdByIndex(index:int):String
		{
			var flavorId:String;
			
			if (index >= 0 && 
				_mediaProxy.vo.kalturaMediaFlavorArray &&
				index < _mediaProxy.vo.kalturaMediaFlavorArray.length)	{
				
				flavorId = (_mediaProxy.vo.kalturaMediaFlavorArray[index] as KalturaFlavorAsset).id;
			}
			
			return flavorId;
		}
	}
}