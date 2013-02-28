package
{
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.ServicesProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.StreamerType;
	import com.kaltura.kdpfl.plugin.WVPluginInfo;
	import com.kaltura.vo.KalturaFlavorAsset;
	import com.kaltura.vo.KalturaWidevineFlavorAsset;
	
	import flash.external.ExternalInterface;
	import flash.net.NetStream;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class WvMediator extends Mediator
	{
		public static const NAME:String = "WvMediator";
		
		public function WvMediator(wvPluginInfo:WVPluginInfo)
		{
			_wvPluginInfo = wvPluginInfo;
			super(NAME);
		}
		
		public var _wvPluginInfo:WVPluginInfo;
		
		override public function listNotificationInterests():Array {
			return [NotificationType.PLAYER_SEEK_END,
					NotificationType.DO_SEEK,
					NotificationType.MEDIA_ELEMENT_READY];
		}
		
		private var _seekTo:Number;
		
		override public function handleNotification(note:INotification):void {
			
			switch (note.getName()) 
			{
				case NotificationType.DO_SEEK:
						_seekTo = note.getBody() as Number;
					break;
					
				case NotificationType.PLAYER_SEEK_END:
						if(_seekTo && _wvPluginInfo && _wvPluginInfo.wvMediaElement && _wvPluginInfo.wvMediaElement.netStream)
							_wvPluginInfo.wvMediaElement.netStream.seek(_seekTo);
						_seekTo = NaN;
					break;
				
				case NotificationType.MEDIA_ELEMENT_READY:
				//	_wvPluginInfo.shouldHandleResource = false;
					var mediaProxy:MediaProxy = facade.retrieveProxy("mediaProxy") as MediaProxy;
					if (mediaProxy.vo.deliveryType==StreamerType.HTTP)
					{
						var flavors:Array = mediaProxy.vo.kalturaMediaFlavorArray;
						if (flavors && flavors.length)
						{
							var wvAssetId:String;
							if (mediaProxy.vo.selectedFlavorId && flavors.length > 1)
							{
								for (var i:int = 0; i<flavors.length; i++)
								{
									var flavor:KalturaFlavorAsset = flavors[i] as KalturaFlavorAsset;
									if (flavor.id == mediaProxy.vo.selectedFlavorId)
									{
										if (flavor is KalturaWidevineFlavorAsset)
										{
											wvAssetId = flavor.id;
											
										}
										break;
									}
								}
							}
						 	//if we don't have selected flavor ID we are playing the first one
							else if (flavors[0] is KalturaWidevineFlavorAsset)
							{
								wvAssetId = (flavors[0] as KalturaWidevineFlavorAsset).id;
							}
							
							if (wvAssetId)
							{
						//		_wvPluginInfo.shouldHandleResource = true;
						//		var emmUrl:String = "http://devtests.kaltura.co.cc/api_v3/index.php?service=widevine_widevinedrm&action=getLicense&format=1&flavorAssetId=" + wvAssetId + "&ks=" + (facade.retrieveProxy(ServicesProxy.NAME) as ServicesProxy).kalturaClient.ks;
						//		ExternalInterface.call("WVSetEmmURL", emmUrl);
							}
						}
					}

					break;
			}
		}
		
	}
}