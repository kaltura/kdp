package com.kaltura.puremvc.as3.core
{
	import com.kaltura.puremvc.as3.patterns.mediator.PriorityMediator;
	import com.kaltura.puremvc.as3.patterns.observer.PriorityObserver;
	
	import flash.sampler.getMemberNames;
	
	import org.puremvc.as3.core.View;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.interfaces.IObserver;
	import org.puremvc.as3.interfaces.IView;
	import org.puremvc.as3.patterns.observer.Observer;

	/**
	 * Class created for creating priority for observers listening for the same notification. 
	 * @author Hila
	 * 
	 */	
	public class KView extends View
	{
		public function KView()
		{
			super();
			priorityMediatorMap = new Array();
			priorityObserverMap = new Array();
		}
		
		public static function getInstance() : IView 
		{
			if ( instance == null ) instance = new KView( );
			return instance;
		}
		/**
		 * 
		 * @param notification
		 * 
		 */		
		override public function notifyObservers(notification:INotification):void
		{
			if ( priorityObserverMap[ notification.getName() ] )
			{
				var notificationPriorityObserver_ref : Array = priorityObserverMap[ notification.getName() ] as Array;
				if ( notificationPriorityObserver_ref.length > 0 )
				{	
					//There can only be 1 priority mediator per notification.
					var priorityObserver : PriorityObserver = notificationPriorityObserver_ref[0];
					priorityObserver.notifyObserver( notification );
				}
				else
				{
					notifyOrdinaryObservers ( notification );
				}
			}
			else
			{
				notifyOrdinaryObservers ( notification );
			}
		}
		
		private function notifyOrdinaryObservers (notification : INotification) : void
		{
			if( observerMap[ notification.getName() ] != null ) {
				
				// Get a reference to the observers list for this notification name
				var observers_ref:Array = observerMap[ notification.getName() ] as Array;
				
				// Copy observers from reference array to working array, 
				// since the reference array may change during the notification loop
				var observers:Array = new Array(); 
				var observer:IObserver;
				for (var i:Number = 0; i < observers_ref.length; i++) { 
					observer = observers_ref[ i ] as IObserver;
					observers.push( observer );
				}
				
				// Notify Observers from the working array				
				for (i = 0; i < observers.length; i++) {
					observer = observers[ i ] as IObserver;
					observer.notifyObserver( notification );
				}
			}
		}
		
		/**
		 * 
		 * @param mediator
		 * 
		 */		
		override public function registerMediator(mediator:IMediator):void
		{
			// do not allow re-registration (you must to removeMediator fist)
			if ( mediatorMap[ mediator.getMediatorName() ] != null ) return;
			
			// Register the Mediator for retrieval by name
			mediatorMap[ mediator.getMediatorName() ] = mediator;
			
			if (mediator is PriorityMediator)
			{
				priorityMediatorMap[ mediator.getMediatorName() ] = mediator;
			}
			
			//Get priority notification interests, if any.
			var priorityInterests : Array = (mediator is PriorityMediator) ? (mediator as PriorityMediator).listPriorityNotificationInterests() : new Array();
			
			if ( priorityInterests.length > 0 )
			{
				PriorityMediator(mediator).setClosureFunc( notifyOrdinaryObservers );
				// Create PriorityObserver for this PriorityMediator's handlePriorityNotification method
				var priorityObserver : PriorityObserver = new PriorityObserver ( (mediator as PriorityMediator).handlePriorityNotification, mediator );
				
				//Register PriorityMediator as PriorityObserver for its list of priority notification interests.
				for each(var interest : String in priorityInterests)
				{
					registerObserver ( interest, priorityObserver );
				}
			}
			
			// Get Notification interests, if any.
			var interests:Array = mediator.listNotificationInterests();
			
			// Register Mediator as an observer for each of its notification interests
			if ( interests.length > 0 ) 
			{
				// Create Observer referencing this mediator's handleNotification method
				var observer:Observer = new Observer( mediator.handleNotification, mediator );
				
				// Register Mediator as Observer for its list of Notification interests
				for ( var i:Number=0;  i<interests.length; i++ ) {
					registerObserver( interests[i],  observer );
				}			
			}
			
			// alert the mediator that it has been registered
			mediator.onRegister();
		}
		/**
		 * 
		 * @param notificationName
		 * @param observer
		 * 
		 */		
		override public function registerObserver(notificationName:String, observer:IObserver):void
		{
			if (observer is PriorityObserver)
			{
				var priorityObservers:Array = priorityObserverMap[ notificationName ];
				
				//Do not allow more than 1 priority mediator per notification. No way to discern which one is more important.
				if( !priorityObservers ) {
					priorityObserverMap[ notificationName ] = [ observer ];	
				}
				else
				{
					// set a variable in the mediator indicating that the mediator cannot be priority-registered to 
					// a certain notification.
				}
			}
			else
			{
				var observers:Array = observerMap[ notificationName ];
				if( observers ) {
					observers.push( observer );
				} else {
					observerMap[ notificationName ] = [ observer ];	
				}
			}
		}
		
		protected var priorityObserverMap : Array;
		
		protected var priorityMediatorMap : Array;
	}
}