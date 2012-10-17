package com.kaltura.kdpfl.events
{
	import flash.events.Event;

	/**
	 * This class subclasses the Event class to allow additional data on the event object.  
	 */	
	public class DynamicEvent extends Event
	{
		/**
		 * additional event data. 
		 */		
		public var data : Object;
		
		public function DynamicEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}