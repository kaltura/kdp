package
{
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class AgeConsentMediator extends Mediator
	{
		static public const NAME:String = "AgeConsentMediator";
		private var _ageConsentCode:ageConsentPlugin;
		public function AgeConsentMediator(viewComponent:*)
		{
			_ageConsentCode = viewComponent;
			super(NAME);
		}
		
		override public function listNotificationInterests():Array {
			return [NotificationType.METADATA_RECEIVED , NotificationType.CHANGE_MEDIA];
		}
		
		override public function handleNotification(note:INotification):void {
			
			switch (note.getName()) 
			{
				case NotificationType.CHANGE_MEDIA:
					_ageConsentCode.clean();
					break;
				case NotificationType.METADATA_RECEIVED:
					var mediaProxy:MediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
					_ageConsentCode.show(mediaProxy.vo.entryMetadata);					
					break;
			}
		}
	}
}