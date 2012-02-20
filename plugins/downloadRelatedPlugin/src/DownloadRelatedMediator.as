package
{
	import com.kaltura.KalturaClient;
	import com.kaltura.kdpfl.model.ServicesProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class DownloadRelatedMediator extends Mediator
	{
		public static const NAME:String = "DownloadRelatedMediator";
		private var _plugin:downloadRelatedPlugin;
		
		
		
		public function DownloadRelatedMediator(viewComponent:downloadRelatedPlugin)
		{
			_plugin = viewComponent;
			super(mediatorName, viewComponent);
		}
		


		override public function listNotificationInterests():Array
		{
			return  [
				NotificationType.MEDIA_READY,"showRelatedFiles",NotificationType.PRE_SEQUENCE_COMPLETE
			];
		}
		
		override public function handleNotification(note:INotification):void
		{
			var media : Object = facade.retrieveProxy("mediaProxy");
			var entryId:String = media["vo"]["entry"]["id"];
			var data:Object = note.getBody();
			
			switch(note.getName())
			{
				case NotificationType.MEDIA_READY:
				case NotificationType.PRE_SEQUENCE_COMPLETE:
					_plugin.client = (facade.retrieveProxy( ServicesProxy.NAME ) as ServicesProxy ).kalturaClient as KalturaClient;
					_plugin.fetchAttachments(entryId);
				break;
				case "showRelatedFiles":
					_plugin.show();
				break;
			}
		}
	}
}


