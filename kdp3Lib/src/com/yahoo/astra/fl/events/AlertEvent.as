package com.yahoo.astra.fl.events
{
	import flash.events.Event;
	
	public class AlertEvent extends Event
	{
		public static const ALERT_REMOVED : String = "alertRemoved";
		
		public function AlertEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}