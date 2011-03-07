package com.kaltura.osmf.events
{
	import flash.events.Event;
	
	public class KSwitchingProxyEvent extends Event
	{
		protected var _switchingProxySwitchContext : String;
		
		public static const ELEMENT_SWITCH_PERFORMED : String = "elementSwitchPerformed";
		
		public function KSwitchingProxyEvent(type:String, switchedTo : String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			switchingProxySwitchContext = switchedTo;
		}

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