package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.model.type.NotificationType;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class AnimationMediator extends Mediator
	{
		public function AnimationMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		override public function  listNotificationInterests():Array{
			return [NotificationType.KDP_READY];
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case NotificationType.KDP_READY:
					break;
			}
		}
	}
}