package com.kaltura.osmf.events
{
	import flash.events.Event;
	/** 
	 * Event fired by the <code>KSwitchingProxyEvent</code> class.
	 * @author Hila
	 * 
	 */	
	public class KSwitchingProxyEvent extends Event
	{
		protected var _switchingProxySwitchContext : String;
		
		public static const ELEMENT_SWITCH_PERFORMED : String = "elementSwitchPerformed";
		public static const ELEMENT_SWITCH_COMPLETED : String = "elementSwitchCompleted";
		public static const ELEMENT_SWITCH_FAILED : String = "elementSwitchFailed";
		
		public function KSwitchingProxyEvent(type:String, switchedTo : String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			switchingProxySwitchContext = switchedTo;
		}
		/**
		 *  parameter indicating what element the Proxy has switched to: main or secondary.
		 * @return 
		 * 
		 */	
		public function get switchingProxySwitchContext():String
		{
			return _switchingProxySwitchContext;
		}

		public function set switchingProxySwitchContext(value:String):void
		{
			_switchingProxySwitchContext = value;
		}

	}
}