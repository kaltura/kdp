package com.kaltura.kdpfl.view.controls
{
	import com.kaltura.kdpfl.model.type.NotificationType;
	
	import fl.controls.Button;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public dynamic class PlayMediator extends Mediator
	{
		public static var NAME:String = "playMediator";
		private static var nameIndex:int = 0;
		

	
		/**
		 * Constructor
		 * add the view component to the wrapper any Button or 
		 * whom inhert from button can be sent to this constructor
		 * and be treated on every click 
		 * @param viewComponent
		 * 
		 */		
		public function PlayMediator(viewComponent:Object=null)
		{
			//so every mediator will have a unique name 
			super(NAME, viewComponent);
			NAME = NAME + (nameIndex++).toString();
			playButton.toggle = true; //play button is always toggle
			playButton.addEventListener(MouseEvent.CLICK, clickHandler);
			
			//workaround to solve some integration bug error
			playButton.addEventListener(Event.CHANGE , onChange );
		}
		
		private function onChange( event : Event ) : void
		{
			event.stopPropagation();
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			if( (e.target as Button).selected )
			{
				sendNotification(NotificationType.DO_PLAY);
			}
			else
			{
				sendNotification(NotificationType.DO_PAUSE );
			}
		}
		
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case NotificationType.PLAYER_PLAY_END:
				case NotificationType.PLAYER_PAUSED:
					playButton.selected = false;
				break;
				
				case NotificationType.PLAYER_PLAYED:
					playButton.selected = true;
				break;
			} 
		}
		
		override public function listNotificationInterests():Array
		{
			return [
					NotificationType.PLAYER_PAUSED,
					NotificationType.PLAYER_PLAYED,
					NotificationType.PLAYER_PLAY_END
				   ];
		}
		
		public function get playButton():Button
		{
			return viewComponent as Button;
		}
		
	}
}