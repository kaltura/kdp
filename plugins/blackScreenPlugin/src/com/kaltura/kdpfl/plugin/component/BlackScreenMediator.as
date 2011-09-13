package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.model.type.NotificationType;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.patterns.observer.Notification;
	
	public class BlackScreenMediator extends Mediator
	{
		public static const NAME : String = "BlackScreenMediator";
		
		public function BlackScreenMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			var returnArray : Array = [NotificationType.PLAYER_UPDATE_PLAYHEAD];
			
			return returnArray;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			
				switch (notification.getName())
				{
					case NotificationType.PLAYER_UPDATE_PLAYHEAD:
						var currentTime : Number = notification.getBody() as Number;
						
						if ((viewComponent as BlackScreenPluginCode).clipStartTime && (viewComponent as BlackScreenPluginCode).clipStartTime != -1 && isNaN(currentTime))
						{
							sendNotification( NotificationType.MUTE );
							(viewComponent as BlackScreenPluginCode).showBlackLayer();
						}
						else if (((viewComponent as BlackScreenPluginCode).clipStartTime != -1 && currentTime < (viewComponent as BlackScreenPluginCode).clipStartTime) || (((viewComponent as BlackScreenPluginCode).clipEndTime != -1) && currentTime > (viewComponent as BlackScreenPluginCode).clipEndTime))
						{
							sendNotification( NotificationType.MUTE );
							(viewComponent as BlackScreenPluginCode).showBlackLayer();
						}
						else
						{
							sendNotification( NotificationType.UNMUTE );
							(viewComponent as BlackScreenPluginCode).hideBlackLayer();
						}
						break;

				}
		}
	}
}