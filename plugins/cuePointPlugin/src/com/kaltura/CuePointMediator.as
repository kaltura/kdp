package com.kaltura
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class CuePointMediator extends Mediator
	{
		public static const NAME : String = "cuePointMediator";
		
		public function CuePointMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			var array : Array = ["receivedCuePoints","entryReady","changeMedia"];
			return array;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var eventName : String = notification.getName();
			var mediaProxy : Object = facade.retrieveProxy("mediaProxy");
			switch (eventName)
			{
				case "receivedCuePoints":
					viewComponent.cuePointArray = notification.getBody() as Array;
					
					if (mediaProxy["vo"]["entry"] && mediaProxy["vo"]["entry"]["duration"])
					{
						viewComponent.entryDuration = mediaProxy["vo"]["entry"]["duration"];
					}
					viewComponent.addCuePoints();
					break;
				
				case "changeMediaProcessStarted" :
					viewComponent.cleanCuePoints();
					break;
			}
		}
	}
}