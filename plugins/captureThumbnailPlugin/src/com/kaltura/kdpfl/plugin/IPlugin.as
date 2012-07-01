package com.kaltura.kdpfl.plugin
{
	import org.puremvc.as3.interfaces.IFacade;
	
	public interface IPlugin
	{
		/**
		 * This function is automatically called by the player after the plugin has loaded.
		 * the facade used to comunicate with the hosted player  
		 * @param 
		 * 
		 */		
		function initializePlugin( facade : IFacade ) : void
		
		/**
		 * 
		 * @param styleName
		 * @param setSkinSize
		 * 
		 */		
		function setSkin( styleName : String , setSkinSize : Boolean = false) : void;
	}
}