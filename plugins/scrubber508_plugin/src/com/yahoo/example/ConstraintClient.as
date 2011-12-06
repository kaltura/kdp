/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.example
{
	import com.yahoo.astra.layout.LayoutManager;
	
	import flash.display.Sprite;
	import flash.events.Event;

	[Event(name="constraintChange")]

	/**
	 * A special type of Sprite designed to work with the ConstraintLayout
	 * algorithm. Uses top, right, bottom, and left constraints for positioning.
	 * 
	 * @see com.yahoo.example.ConstraintLayout
	 * @author Josh Tynjala
	 */
	public class ConstraintClient extends Sprite
	{
		
	//--------------------------------------
	//  Static
	//--------------------------------------
	
		//register the constraintChange event with the layout manager
		//to ensure that changes to these properties will update the parent
		//layout containers
		LayoutManager.registerInvalidatingEvents(ConstraintClient, ["constraintChange"]);
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function ConstraintClient()
		{
			super();
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
		 * @private
		 * Storage for the left property.
		 */
		private var _left:Number = NaN;
		
		/**
		 * The display object will be constrained this number of pixels from the
		 * left edge of the parent layout container. To clear this value, set it
		 * to NaN.
		 * 
		 * <p>Note: Must be combined with the ConstraintLayout algorithm for this
		 * value to be used.</p> 
		 */
		public function get left():Number
		{
			return this._left;
		}
		
		/**
		 * @private
		 */
		public function set left(value:Number):void
		{
			this._left = value;
			this.dispatchEvent(new Event("constraintChange"));
		}
		
		/**
		 * @private
		 * Storage for the right property.
		 */
		private var _right:Number = NaN;
		
		
		/**
		 * The display object will be constrained this number of pixels from the
		 * right edge of the parent layout container. To clear this value, set it
		 * to NaN.
		 * 
		 * <p>Note: Must be combined with the ConstraintLayout algorithm for this
		 * value to be used.</p> 
		 */
		public function get right():Number
		{
			return this._right;
		}
		
		/**
		 * @private
		 */
		public function set right(value:Number):void
		{
			this._right = value;
			this.dispatchEvent(new Event("constraintChange"));
		}
		
		/**
		 * @private
		 * Storage for the top property.
		 */
		private var _top:Number = NaN;
		
		
		/**
		 * The display object will be constrained this number of pixels from the
		 * top edge of the parent layout container. To clear this value, set it
		 * to NaN.
		 * 
		 * <p>Note: Must be combined with the ConstraintLayout algorithm for this
		 * value to be used.</p> 
		 */
		public function get top():Number
		{
			return this._top;
		}
		
		/**
		 * @private
		 */
		public function set top(value:Number):void
		{
			this._top = value;
			this.dispatchEvent(new Event("constraintChange"));
		}
		
		/**
		 * @private
		 * Storage for the bottom property.
		 */
		private var _bottom:Number = NaN;
		
		
		/**
		 * The display object will be constrained this number of pixels from the
		 * bottom edge of the parent layout container. To clear this value, set it
		 * to NaN.
		 * 
		 * <p>Note: Must be combined with the ConstraintLayout algorithm for this
		 * value to be used.</p> 
		 */
		public function get bottom():Number
		{
			return this._bottom;
		}
		
		/**
		 * @private
		 */
		public function set bottom(value:Number):void
		{
			this._bottom = value;
			this.dispatchEvent(new Event("constraintChange"));
		}
		
	}
}