package
{
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.type.EnableType;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.vo.KalturaBaseEntry;
	import com.kaltura.vo.KalturaPlayableEntry;
	
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class AdvancedShareMediator extends Mediator
	{
		public static const NAME:String = "AdvancedShareMediator";
		
		private var _advancedSharePlugin:shareSnippetPlugin; 
		
		public var entry:KalturaBaseEntry;
		public var metadata:Object;
		public var mediaProxy:MediaProxy
		
		public var duringShare:Boolean;
		
		
		public function AdvancedShareMediator(asp:shareSnippetPlugin=null)
		{
			_advancedSharePlugin = asp;
			super(NAME, _advancedSharePlugin);
		}
		public function init():void
		{
			mediaProxy = facade.retrieveProxy("mediaProxy") as MediaProxy;
		}
		
		override public function listNotificationInterests():Array
		{
			return ['showAdvancedShare',
				NotificationType.MEDIA_READY,
				NotificationType.PLAYER_PLAYED,
				NotificationType.PLAYER_PAUSED,
				NotificationType.METADATA_RECEIVED];
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			var noteName:String = notification.getName();
			
			switch(noteName)
			{
				
				case NotificationType.PLAYER_PLAYED:
					_advancedSharePlugin.wasPlayerPlaying = true;
					break;
				case NotificationType.PLAYER_PAUSED:
					if(!duringShare)
						_advancedSharePlugin.wasPlayerPlaying = false;
					break;
				
				
				case "showAdvancedShare":
					_advancedSharePlugin.generate(); 
					duringShare = true;
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