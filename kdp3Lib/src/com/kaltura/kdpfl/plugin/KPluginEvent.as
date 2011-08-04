package com.kaltura.kdpfl.plugin
{
	import flash.events.Event;
	/**
	 * New class for unique events fired by the KDP plug-ins 
	 * @author Hila
	 * 
	 */	
	public class KPluginEvent extends Event
	{
		/**
		 * Constant signifying plugin initialize complete.
		 */		
		public static const KPLUGIN_INIT_COMPLETE : String = "kPluginInitComplete";
		/**
		 * Constant signifying plugin initialize failed.
		 */		
		public static const KPLUGIN_INIT_FAILED : String = "kPluginInitFailed";
		/**
		 *  
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 * 
		 */		
		public function KPluginEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}