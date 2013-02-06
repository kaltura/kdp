package
{
	import com.kaltura.kdpfl.model.type.NotificationType;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class AnimatedScrubberThumbMediator extends Mediator
	{
		public function AnimatedScrubberThumbMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		override public function listNotificationInterests():Array{
			return [NotificationType.DURATION_CHANGE, NotificationType.CHANGE_MEDIA, NotificationType.PLAYBACK_COMPLETE];
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case NotificationType.DURATION_CHANGE:
					(viewComponent as AnimatedScrubberThumbCode).duration	= Number(notification.getBody().newValue);
					break;
				case NotificationType.CHANGE_MEDIA:
					break;
				case NotificationType.PLAYBACK_COMPLETE:
					(viewComponent as AnimatedScrubberThumbCode).playbackComplete();
					break;
			}
		}
	}
}