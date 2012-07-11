package
{
	import com.kaltura.KalturaClient;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.type.EnableType;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.vo.KalturaBaseEntry;
	
	import org.osmf.media.MediaPlayer;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class AdvancedShareMediator extends Mediator
	{
		public static const NAME:String = "advancedShareMediator";
		
		private var _advancedSharePlugin:sharePlugin; 
		
		public var entry:KalturaBaseEntry;
		public var metadata:Object;
		public var mediaProxy:MediaProxy
		
		public function AdvancedShareMediator(asp:sharePlugin=null)
		{
			_advancedSharePlugin = asp;
			
			super(NAME, _advancedSharePlugin);
		}
		public function init():void
		{
			mediaProxy = facade.retrieveProxy("mediaProxy") as MediaProxy;
			_advancedSharePlugin.kc = facade.retrieveProxy("servicesProxy")["kalturaClient"] as KalturaClient;
		}
		
		override public function listNotificationInterests():Array
		{
			return ['showAdvancedShare',
				NotificationType.MEDIA_READY,
				NotificationType.METADATA_RECEIVED];
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			var noteName:String = notification.getName();
			var vobj:MediaPlayer = facade["bindObject"]["video"].player as MediaPlayer;
			
			
			switch(noteName)
			{
				case "showAdvancedShare":
					facade.sendNotification("closeFullScreen");
					_advancedSharePlugin.wasPlayerPlaying = vobj.playing;
					_advancedSharePlugin.generate(); 
					if(_advancedSharePlugin.wasPlayerPlaying)
						sendNotification(NotificationType.DO_PAUSE);
						
					_advancedSharePlugin.visible =  true;
					sendNotification(NotificationType.ENABLE_GUI,{guiEnabled : false , enableType : EnableType.FULL});
					
					
					
					
					break;
				case NotificationType.METADATA_RECEIVED:
					if(!metadata )
						metadata = mediaProxy.vo.entryMetadata;
					
					break;
				case NotificationType.MEDIA_READY:
					entry = mediaProxy.vo.entry
					break;
			}
		}
	}
}