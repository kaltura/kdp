package com.kaltura.kdpfl.plugin
{
	/**
	 * Interface for the KDP PluginFactory class. 
	 * @author Hila
	 * 
	 */	
	public interface IPluginFactory
	{
		/**
		 * this function creates a new IPlugin instance. It is implemented by the plugin application class 
		 * @param pluginName the name of the plugin to be created in case there are multiple plugins within
		 * the same plugin swf file 
		 * @return 
		 * 
		 */
		function create(pluginName : String = null) : IPlugin;	
	}
}