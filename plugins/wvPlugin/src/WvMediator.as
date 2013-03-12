package
{
	import com.kaltura.KalturaClient;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.ServicesProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.StreamerType;
	import com.kaltura.kdpfl.plugin.WVPluginInfo;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	import com.kaltura.vo.KalturaFlavorAsset;
	import com.kaltura.vo.KalturaMediaEntry;
	import com.kaltura.vo.KalturaWidevineFlavorAsset;
	
	import flash.external.ExternalInterface;
	import flash.net.NetStream;
	
	import org.osmf.traits.AudioTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.TimeTrait;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class WvMediator extends Mediator
	{
		public static const NAME:String = "WvMediator";
		/**
		 * indicates the next flavor should start playback from this position 
		 */		
		public var pendingSeekTo:Number = 0;
		/**
		 * last playhead position 
		 */		
		private var _lastPlayhead:Number;
		/**
		 * indicates next play should call wvNetstrea.replay 
		 */		
		private var _isReplay:Boolean;	
		/**
		 * max seek point within wv netstream 
		 */		
		private var _maxSeek:Number;
		/**
		 * indicates if the player is currently playing wv netstream 
		 */		
		private var _isWv:Boolean;		
		/**
		 * after wv netstream has already reported  netstream complete we need to ignore all doSeek requests
		 */		
		public var ignoreSeek:Boolean;
		
		public var wvPluginInfo:WVPluginInfo;
		
		public function WvMediator(wvPI:WVPluginInfo)
		{
			wvPluginInfo = wvPI;
			super(NAME);
		}
		
		
		
		override public function listNotificationInterests():Array {
			return [NotificationType.DO_SEEK,
					NotificationType.MEDIA_ELEMENT_READY,
					NotificationType.PLAYER_UPDATE_PLAYHEAD,
					NotificationType.PLAYER_PLAY_END,
					NotificationType.DO_PLAY,
					NotificationType.BUFFER_PROGRESS,
					NotificationType.CHANGE_MEDIA];
		}
		
		
		override public function handleNotification(note:INotification):void {
			var mediaProxy:MediaProxy = facade.retrieveProxy("mediaProxy") as MediaProxy;
			
			switch (note.getName()) 
			{
				case NotificationType.DO_SEEK:
					if (!ignoreSeek && _isWv)
					{
						var seekTo:Number = note.getBody() as Number;
						if(wvPluginInfo && wvPluginInfo.wvMediaElement && wvPluginInfo.wvMediaElement.netStream)
						{	
							//cannot seek to the complete end, wv bug
							seekWvStream(Math.min(seekTo, _maxSeek));
						}
					}
						
					break;
				
				case NotificationType.MEDIA_ELEMENT_READY:					
					//get flavor asset ID
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
								_isWv = true;
								var kc:KalturaClient = (facade.retrieveProxy(ServicesProxy.NAME) as ServicesProxy).kalturaClient;
								var emmUrl:String = kc.protocol + kc.domain + "/api_v3/index.php?service=widevine_widevinedrm&action=getLicense&format=widevine&flavorAssetId=" + wvAssetId + "&ks=" +kc.ks;
								ExternalInterface.call("WVSetEmmURL", emmUrl);
								
								var playerMediator:KMediaPlayerMediator = facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator;
								//workaround for wv bug, netstream reports end before actual end
								playerMediator.ignorePlaybackComplete = true;

							}
							else
							{
								_isWv = false;
							}
							
						}
					}

					break;
	
				
				case NotificationType.PLAYER_UPDATE_PLAYHEAD:
					//in case we switch flavors we want to save last position
					if (_isWv)
						_lastPlayhead = note.getBody() as Number;
					break;
					
				case NotificationType.PLAYER_PLAY_END:
					if (_isWv)
						_isReplay = true;
					break;
				
				case NotificationType.DO_PLAY:
					if (_isWv && _isReplay)
					{
						wvPluginInfo.wvMediaElement.netStream.replay();
						_isReplay = false;
					}
					break;
				
				case NotificationType.BUFFER_PROGRESS:
					//calculate max seek position in wv netstream
					if (_isWv)
						_maxSeek = (mediaProxy.vo.entry as KalturaMediaEntry).duration - note.getBody().newTime;
					
					break;
				
				case NotificationType.CHANGE_MEDIA:
					_isReplay = false;
					var kmediaMediator:KMediaPlayerMediator = facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator;
					if (mediaProxy.vo.isFlavorSwitching)
						pendingSeekTo = _lastPlayhead;
					break;
			}
		}
		
		public function seekWvStream(seekTo:Number): void
		{
			wvPluginInfo.wvMediaElement.netStream.seek(seekTo);
		}
		
	}
}