package com.kaltura.puremvc.as3.interfaces
{
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	/**
	 * New interface allowing mediators to register for certain notifications before any other observer and execute their code before 
	 * notification is pushed to any other observer. 
	 * @author Hila
	 * 
	 */	
	public interface IPriorityMediator extends IMediator
	{
		/**
		 * Function which returns an array of the notification the priority mediator needs to 
		 * obtain before any other observer. 
		 * @return Array of notification that the mediator has priority access to.
		 * 
		 */		
		function listPriorityNotificationInterests () : Array;
		/**
		 * Function which handles a priority notification. 
		 * @param notification
		 * 
		 */		
		function handlePriorityNotification ( notification : INotification ) : void;
	}
}