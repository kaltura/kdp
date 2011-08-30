/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.events
{
	import flash.events.Event;
	
	/**
	 * The MenuButtonRowEvent class defines events for the MenuButtonRow component. 
	 * 
	 * These events include the following:
	 * <ul>
	 * <li><code>MenuButtonRowEvent.ITEM_DOWN</code>: dispatched after the user mouses down over an item in the component.</li>
	 * <li><code>MenuButtonRowEvent.ITEM_ROLL_OUT</code>: dispatched after the user rolls the mouse pointer out of an item in the component.</li>
	 * <li><code>MenuButtonRowEvent.ITEM_ROLL_OVER</code>: dispatched after the user rolls the mouse pointer over an item in the component.</li>
	 * <li><code>MenuButtonRowEvent.ITEM_UP</code>: dispatched after the user mouses up over an item in the component.</li>
	 * </ul>
	 *
     * @see com.yahoo.astra.fl.controls.MenuButtonRow 
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     * @author Dwight Bridges
	 */
	public class MenuButtonRowEvent extends Event
	{
		
	//--------------------------------------
	//  Constants
	//--------------------------------------
	
		/**
         * Defines the value of the <code>type</code> property of an <code>itemClick</code> 
		 * event object. 
		 * 
		 * <p>This event has the following properties:</p>
		 *  <table class="innertable" width="100%">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *     <tr><td><code>cancelable</code></td><td><code>true</code></td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing 
         *          the event object with an event listener.</td></tr>
		 * 	  <tr><td><code>index</code></td><td>The zero-based index in the DataProvider
		 * 			that contains the renderer.</td></tr>
		 * 	  <tr><td><code>item</code></td><td>A reference to the data that belongs to the renderer.
		 * 	  <tr><td><code>target</code></td><td>The object that dispatched the event. The target is 
         *           not always the object listening for the event. Use the <code>currentTarget</code>
		 * 			property to access the object that is listening for the event.</td></tr>
		 * 	  		</td></tr>
		 *  </table>
         *
         * @eventType itemClick
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public static const ITEM_DOWN:String = "itemDown";
		
		/**
         * Defines the value of the <code>type</code> property of an <code>itemRollOver</code> 
		 * event object. 
		 * 
		 * <p>This event has the following properties:</p>
		 *  <table class="innertable" width="100%">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *     <tr><td><code>cancelable</code></td><td><code>false</code>; there is 
		 *          no default behavior to cancel.</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing 
         *          the event object with an event listener.</td></tr>
		 * 	  <tr><td><code>index</code></td><td>The zero-based index in the DataProvider
		 * 			that contains the renderer.</td></tr>
		 * 	  <tr><td><code>item</code></td><td>A reference to the data that belongs to the renderer.</td></tr>
		 * 	  <tr><td><code>target</code></td><td>The object that dispatched the event. The target is 
         *           not always the object listening for the event. Use the <code>currentTarget</code>
		 * 			property to access the object that is listening for the event.</td></tr>
		 *  </table>
         *
         * @eventType itemRollOver
		 *
         * @see #ITEM_ROLL_OUT
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public static const ITEM_ROLL_OVER:String = "itemRollOver";
		
		/**
		 * Defines the value of the <code>type</code> property on an <code>itemUp</code>
		 * event object.
		 * 
		 * <p>This event has the following properties:</p>
		 *  <table class="innertable" width="100%">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *     <tr><td><code>cancelable</code></td><td><code>false</code>; there is 
		 *          no default behavior to cancel.</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing 
         *          the event object with an event listener.</td></tr>
		 * 	  <tr><td><code>index</code></td><td>The zero-based index in the DataProvider
		 * 			that contains the renderer.</td></tr>
		 * 	  <tr><td><code>item</code></td><td>A reference to the data that belongs to the renderer.</td></tr>
		 * 	  <tr><td><code>target</code></td><td>The object that dispatched the event. The target is 
         *           not always the object listening for the event. Use the <code>currentTarget</code>
		 * 			property to access the object that is listening for the event.</td></tr>
		 *  </table>
         *
         * @eventType itemUp
         *
         * @see #ITEM_UP
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */		
		public static const ITEM_UP:String = "itemUp";
		
		/**
         * Defines the value of the <code>type</code> property of an  
		 * <code>itemRollOut</code> event object. 
		 * 
		 * <p>This event has the following properties:</p>
		 *  <table class="innertable" width="100%">
		 *    <tr>
         *      <th>Property</th>
         *      <th>Value</th>
         *    </tr>
		 *    <tr>
         *      <td><code>bubbles</code></td>
         *      <td><code>false</code></td></tr>
		 *    <tr><td><code>cancelable</code></td><td><code>false</code>; there is
		 *          no default behavior to cancel.</td></tr>	
		 * 	  <tr><td><code>currentTarget</code></td><td>The object that is actively processing 
         *          the event object with an event listener.</td></tr>
		 * 	  <tr><td><code>index</code></td><td>The zero-based index in the DataProvider
		 * 			that contains the renderer.</td></tr>
		 * 	  <tr><td><code>item</code></td><td>A reference to the data that belongs to the renderer.</td></tr>
		 * 	  <tr><td><code>target</code></td><td>The object that dispatched the event. The target is 
         *           not always the object listening for the event. Use the <code>currentTarget</code>
		 * 			property to access the object that is listening for the event.</td></tr>
         *  </table>
         *
         * @eventType itemRollOut
         *
         * @see #ITEM_ROLL_OVER
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public static const ITEM_ROLL_OUT:String = "itemRollOut";
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor. Creates a new MenuButtonRowEvent object with the specified parameters. 
		 * 
         * @param type The event type; this value identifies the action that caused the event.
         *
         * @param bubbles Indicates whether the event can bubble up the display list hierarchy.
         *
         * @param cancelable Indicates whether the behavior associated with the event can be
		 *        prevented.
         *
         * @param index The zero-based index of the item in the DataProvider. 
         *
         * @param item A reference to the data that belongs to the renderer. 
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function MenuButtonRowEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, index:int = -1, item:Object = null, label:String = "")
		{
			super(type, bubbles, cancelable);
			this.index = index;
			this.item = item;
			this.label = label;
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
         * The zero-based index of the cell that contains the renderer.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public var index:int = -1;
		
		/**
         * The data that belongs to the current cell renderer.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public var item:Object = null;
		
		/**
         * The label of the current cell renderer.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */		
		public var label:String = "";
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
	
		/**
		 * Creates a copy of the MenuButtonRowEvent object and sets the value of each parameter to match
		 * the original.
		 *
         * @return A new MenuButtonRowEvent object with parameter values that match those of the original.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override public function clone():Event
		{
			return new MenuButtonRowEvent(this.type, this.bubbles, this.cancelable, this.index, this.item, this.label);
		}
		
	}
}