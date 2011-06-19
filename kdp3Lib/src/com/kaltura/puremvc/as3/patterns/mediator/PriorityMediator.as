package com.kaltura.puremvc.as3.patterns.mediator
{
	import com.kaltura.puremvc.as3.interfaces.IPriorityMediator;
	
	import mx.events.CloseEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * New type of mediator, capable of obtaining a notification first of all other
	 * observers. 
	 * @author Hila
	 * 
	 */	
	public class PriorityMediator extends Mediator implements IPriorityMediator
	{
		
		public function PriorityMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		/**
		 * Basic implementation of the function which "lists" the notifications
		 * the mediator requires priority access to.
		 * @return 
		 * 
		 */		
		public function listPriorityNotificationInterests () : Array
		{
			return [ ];
		}
		/**
		 * Basic implementation of interface method handlePriorityNotification 
		 * @param notification
		 * 
		 */		
		public function handlePriorityNotification ( notification : INotification ) : void
		{
			
		}
		
		public function handleComplete ( notification : INotification ) : void
		{
			closureFunc ( notification );
		}
		
		public function setClosureFunc ( value : Function ) : void
		{
			closureFunc = value;
		}
		
		protected var closureFunc : Function; 
		
	}
}