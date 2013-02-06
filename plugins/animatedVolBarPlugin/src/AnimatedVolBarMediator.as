package
{
	import com.kaltura.kdpfl.model.type.NotificationType;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class AnimatedVolBarMediator extends Mediator
	{
		public function AnimatedVolBarMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		override public function listNotificationInterests():Array{
			return [NotificationType.VOLUME_CHANGED, NotificationType.VOLUME_CHANGED_END, NotificationType.KDP_READY];
		}
		
		override public function handleNotification(notification:INotification):void{
			switch (notification.getName()){
				case NotificationType.VOLUME_CHANGED:
					break;
				case NotificationType.VOLUME_CHANGED_END:
					break;
				case NotificationType.KDP_READY:
					(viewComponent as AnimatedVolBarCode).initLayout();
					break;
			}
		}
		
	}
}