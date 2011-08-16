/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.controls.carouselClasses
{
	import com.yahoo.astra.fl.controls.Carousel;
	
	import flash.events.IEventDispatcher;
	
	/**
	 * A swappable layout system for a Carousel component.
	 * 
	 * <p>Expected to be a subclass of Sprite or fl.core.UIComponent.</p>
	 * 
	 * @see fl.core.UIComponent
	 */
	public interface ICarouselLayoutRenderer extends IEventDispatcher
	{
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
		 * The x position, in pixels, of the layout renderer.
		 */
		function get x():Number;
		
		/**
		 * The y position, in pixels, of the layout renderer.
		 */
		function get y():Number;
		
		/**
		 * The width, in pixels, of the layout renderer.
		 */
		function get width():Number;
		
		/**
		 * The height, in pixels, of the layout renderer.
		 */
		function get height():Number;
	
		/**
		 * The carousel for which this layout renderer draws and positions the items.
		 */
		function get carousel():Carousel;
		
		/**
		 * @private
		 */
		function set carousel(value:Carousel):void;
	
	//--------------------------------------
	//  Methods
	//--------------------------------------
		
		/**
		 * Moves the layout renderer to a new position.
		 * 
		 * @param x			The new x position.
		 * @param y			The new y position.
		 */
		function move(x:Number, y:Number):void;
		
		/**
		 * Resizes the layout renderer.
		 * 
		 * @param width		The new width value.
		 * @param height	The new height value.
		 */
		function setSize(width:Number, height:Number):void;
		
		/**
		 * Draws the layout renderer immediately.
		 * 
		 * @see fl.controls.UIComponent#drawNow
		 */
		function drawNow():void;
		
		/**
		 * Designed to allow the clean up any references to cell renderers.
		 * Event listeners are the most common reference that should be removed.
		 */
		function cleanUp():void;
	}
}