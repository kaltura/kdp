package com.kaltura.kdpfl.model.type
{
	/**
	 * This class defines constants representing a plugin status 
	 * @author Michal
	 * 
	 */	
	public class PluginStatus
	{
		/**
		 * indicates the plugin was loaded successfully 
		 */		
		public static const READY:String = "ready";
		/**
		 * indicates the plugin is not ready yet 
		 */		
		public static const NOT_READY:String = "notReady";
		/**
		 * indicates the plugin failed to load
		 */		
		public static const LOAD_ERROR:String = "loadError";
		
	}
}