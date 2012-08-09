package com.kaltura.kdpfl.view.controls
{
	import com.kaltura.kdpfl.util.KTextParser;
	import com.kaltura.puremvc.as3.patterns.mediator.MultiMediator;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class FuncWrapper extends MultiMediator
	{
		private var _action:String;
		private var _component:IEventDispatcher;

		private var _notificationsArr:Array;
		private var _actionsArr:Array;
	
		public function FuncWrapper(viewComponentObject:Object = null)
		{
			super(viewComponentObject);
			_notificationsArr = new Array();
			_actionsArr = new Array();
		}
		
		/**
		 * Add event listenet to the given component 
		 * @param component the compoenet to add the listener to
		 * @param type the event to listen for
		 * @param action the action to perform once the event was dispatched
		 * 
		 */		
		public function registerToEvent(component:IEventDispatcher, type:String, action:String) : void
		{
			this._action = action;
			this._component = component;		
			component.addEventListener(type, func); 
		}
		
		private function func(e:Event):void
		{
			executeAction(_action);
		}
		
		/**
		 * Performs the given action once the given notification was dispatched 
		 * @param notificationName the notification to listen for
		 * @param action the action to perform
		 * 
		 */		
		public function registerToNotification (notificationName:String, action:String) : void {
			_notificationsArr.push(notificationName);
			_actionsArr.push(action);
		} 
		
		/**
		 *  
		 * @return array of relevant notifications 
		 * 
		 */		
		override public function listNotificationInterests():Array
		{
			return _notificationsArr;
		}
		
		/**
		 * Handles the dispatched notifiction 
		 * @param note
		 * 
		 */		
		override public function handleNotification(note:INotification):void
		{
			executeAction(_actionsArr[_notificationsArr.indexOf(note.getName())]);
		}
		
		private function executeAction(action:String):void {
			KTextParser.execute(facade['bindObject'], action);
		}

	}
}