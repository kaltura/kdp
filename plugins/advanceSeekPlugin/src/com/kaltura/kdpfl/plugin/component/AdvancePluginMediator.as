package com.kaltura.kdpfl.plugin.component
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class AdvancePluginMediator extends Mediator
	{
		
		public static const NAME:String = "AdvancePluginMediator";
		private var currentDuration:Number;
		private var currentPosition:Number;
		
		public function AdvancePluginMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		override public function listNotificationInterests():Array
		{
			return [
					"seekForward",
					"seekBackwards",
					"seekPercentage",
					"playerUpdatePlayhead",
					"durationChange"
					];
		} 
		/**
		 * Handle relevant notifications  
		 * @param note
		 * 
		 */		
		override public function handleNotification(note:INotification):void
		{
			var toPoint:Number;
			
			switch(note.getName())
			{
				// jump X seconds forward
				case "seekForward":
					toPoint = Number(currentPosition + Number(note.getBody()));
					if (toPoint >= currentDuration)
						toPoint = currentDuration;
					
				break;
				// jump X seconds backwords
				case "seekBackwards":
					toPoint = Number(currentPosition - Number(note.getBody()));
					if (toPoint <= 0)
						toPoint = 0;
				break;
				//seek to a precentage of the current media duration
				case "seekPercentage":
					toPoint = currentDuration * Number(note.getBody())/100;
				break;
				case "durationChange":
					currentDuration = Number(note.getBody().newValue);
				break;
				case "playerUpdatePlayhead":
					currentPosition = Number(note.getBody());
				break;
			}	
			if (toPoint)
				facade.sendNotification("doSeek",  toPoint);
		}		
		
	}
}