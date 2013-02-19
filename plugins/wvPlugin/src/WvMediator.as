package
{
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.plugin.WVPluginInfo;
	
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
			return [NotificationType.PLAYER_SEEK_END,NotificationType.DO_SEEK];
		}
		
		private var _seekTo:Number;
		
		override public function handleNotification(note:INotification):void {
			var mediaProxy:MediaProxy = facade.retrieveProxy("mediaProxy") as MediaProxy;
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
			}
		}
		
	}
}