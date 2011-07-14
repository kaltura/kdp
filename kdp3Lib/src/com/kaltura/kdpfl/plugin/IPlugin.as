package com.kaltura.kdpfl.plugin
{
	import org.puremvc.as3.interfaces.IFacade;
	/**
	 * Interface for the KDP plugins. 
	 * @author Hila
	 * 
	 */	
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
		 * Function sets the visual assets of the plugin according to styleName.
		 * @param styleName - state of the plugin to assign a skin class to (i.e overSkin, upSkin, etc).
		 * @param setSkinSize - optional flag indicating whether the skin size should be changed to the component size.
		 * 
		 */		
		function setSkin( styleName : String , setSkinSize : Boolean = false) : void;
	}
}