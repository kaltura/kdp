package com.kaltura.kdpfl.component
{
	public interface IComponent
	{
		/**
		 * 
		 * 
		 */		
		function initialize() : void; //initilize the component behavior
		
		/**
		 * 
		 * @param styleName
		 * @param setSkinSize
		 * 
		 */		
		function setSkin( styleName : String , setSkinSize : Boolean = false) : void;
	}
}