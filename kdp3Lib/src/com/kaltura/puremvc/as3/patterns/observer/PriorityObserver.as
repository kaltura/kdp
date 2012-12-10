package com.kaltura.puremvc.as3.patterns.observer
{
	import org.puremvc.as3.patterns.observer.Observer;
	
	public class PriorityObserver extends Observer
	{
		protected var priorityNotifications : Array;
		
		public function PriorityObserver(notifyMethod:Function, notifyContext:Object)
		{
			super(notifyMethod, notifyContext);
		}
	}
}