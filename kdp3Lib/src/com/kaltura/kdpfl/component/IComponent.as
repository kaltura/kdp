package com.kaltura.kdpfl.component
{
	/**
	 * Interface for the UIComponents used be the KDP. 
	 * @author Hila
	 * 
	 */	
	public interface IComponent
	{
		/**
		 * This function initializes the component behavior.
		 * 
		 */		
		function initialize() : void; 
		
		/**
		 * Function assigns the component's state a visual class from the skin.swf file.
		 * @param styleName the name of the component's state to assign a visual class to (i.e : upSkin, overSkin, downSkin).
		 * @param setSkinSize flag signifying whether to set the button size according to the size of the skin.
		 * 
		 */		
		function setSkin( styleName : String , setSkinSize : Boolean = false) : void;
	}
}