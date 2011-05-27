package com.kaltura.kdpfl.view.controls
{
	import com.kaltura.kdpfl.model.type.NotificationType;
	
	import fl.controls.Button;
	
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	/**
	 * Mediator for the Full Screen button. This class is responsible for firing the required KDP notifications when the user clicks the full
	 * screen button, as well as controlling the button's <code>selected</code> property. 
	 * @author Hila
	 * 
	 */
	public class FullscreenMediator extends Mediator
	{
		public static var NAME:String = "FullscreenMediator";
		private static var nameIndex:int = 0;
		
		private var stageInstance:Stage;
		
		/**
		 * C'tor 
		 * @param viewComponent -  should be a toggle (selected) button 
		 */
		public function FullscreenMediator(viewComponent:Object=null)
		{
			//so every mediator will have a unique name 
			NAME = NAME + (nameIndex++).toString();
			super(NAME, viewComponent);
			fullScreenButton.toggle = true; //play button is always toggle
			fullScreenButton.addEventListener(MouseEvent.CLICK, clickHandler);	
		}
		
		/**
		 * listen to the click of the button and send notification open/close fullscreen
		 */ 
		private function clickHandler(event:MouseEvent):void
		{
			if( (event.target as Button).selected )
				sendNotification(NotificationType.OPEN_FULL_SCREEN);		
			else
				sendNotification(NotificationType.CLOSE_FULL_SCREEN);
		}
		
		/**
		 * Handle CLOSE_FULL_SCREEN/OPEN_FULL_SCREEN notifications, no mater 
		 * who initiated it. The OPEN_FULL_SCREEN is in try/catch to prevent 
		 * errors in case the swf is not allowed to use fullscreen
		 */
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case NotificationType.HAS_CLOSED_FULL_SCREEN:
					fullScreenButton.selected = false;
				break;
				case NotificationType.HAS_OPENED_FULL_SCREEN:
					fullScreenButton.selected = true;
				break;
			}
		}
		/**
		 * OPEN_FULL_SCREEN
		 * CLOSE_FULL_SCREEN
		 */
		override public function listNotificationInterests():Array
		{
			return [
					NotificationType.HAS_CLOSED_FULL_SCREEN,
					NotificationType.HAS_OPENED_FULL_SCREEN,
				   ];
		}
		
		public function get fullScreenButton():Button
		{
			return viewComponent as Button;
		}	
	}
}