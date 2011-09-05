package com.kaltura.osmf.events
{
	/**
	 * Class containing the context types for an element switch performed by the <code>KSwitchingProxySwitchContext</code>.
	 * @author Hila
	 * 
	 */	
	public class KSwitchingProxySwitchContext
	{
		/**
		 * Indicates the secondary media element, usually a midroll. 
		 */		
		public static const SECONDARY : String = "secondary";
		/**
		 * Indicates the main media element being played by the KDP. 
		 */		
		public static const MAIN : String = "main";
	}
}