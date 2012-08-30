package com.kaltura.kdpfl.plugin
{
	import com.akamai.playeranalytics.AnalyticsPluginLoader;
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
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
			return [NotificationType.MEDIA_READY, NotificationType.MEDIA_ELEMENT_READY, NotificationType.SWITCHING_CHANGE_COMPLETE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationType.MEDIA_READY:
					//populate analytics metadata
					var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
					var entry:KalturaBaseEntry = _mediaProxy.vo.entry;
					
					AnalyticsPluginLoader.setData("title", entry.id);
					
					AnalyticsPluginLoader.setData("category", entry.categories);
				
					//since we don't have a partnerID field, we will send it as "subCategory"
					AnalyticsPluginLoader.setData("subCategory", configProxy.vo.flashvars.partnerId);
					
					//find content type
					if (entry is KalturaMediaEntry)
					{
						var mediaEntry:KalturaMediaEntry = entry as KalturaMediaEntry;
						
						AnalyticsPluginLoader.setData("contentLength", mediaEntry.duration);
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
						AnalyticsPluginLoader.setData("contentType", contentType);
					}
					
					AnalyticsPluginLoader.setData("device", Capabilities.os );
					AnalyticsPluginLoader.setData("playerId", configProxy.vo.flashvars.uiConfId);
				
					break;
				
			
				case NotificationType.SWITCHING_CHANGE_COMPLETE:
					AnalyticsPluginLoader.setData("show", getFlavorIdByIndex(notification.getBody().newIndex));
					break;
				
				case NotificationType.MEDIA_ELEMENT_READY:
					//find starting flavor ID
					var flavorId:String;
					if (_mediaProxy.vo.deliveryType == StreamerType.HTTP)
					{
						flavorId = _mediaProxy.vo.selectedFlavorId;						
					}
					else if (_mediaProxy.vo.deliveryType == StreamerType.RTMP)
					{	
						flavorId = getFlavorIdByIndex(_mediaProxy.startingIndex);
					}
					
					//since we don't have "flavor" field, we will send it as "show"
					if (flavorId)
						AnalyticsPluginLoader.setData("show", flavorId);
					
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