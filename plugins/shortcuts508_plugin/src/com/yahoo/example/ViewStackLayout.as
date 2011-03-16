/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.example
{
	import com.yahoo.astra.layout.events.LayoutEvent;
	import com.yahoo.astra.layout.modes.ILayoutMode;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;

	/**
	 * A specialized layout that displays a single child of the target DisplayObjectContainer
	 * based on a selected index.
	 * 
	 * @author Josh Tynjala
	 */
	public class ViewStackLayout extends EventDispatcher implements ILayoutMode
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function ViewStackLayout()
		{
			super();
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
		 * @private
		 * Storage for the selectedIndex property.
		 */
		private var _selectedIndex:int = 0;
		
		/**
		 * The child at the selected index will be displayed and all other children hidden.
		 */
		public function get selectedIndex():int
		{
			return this._selectedIndex;
		}
		
		/**
		 * @private
		 */
		public function set selectedIndex(value:int):void
		{
			this._selectedIndex = value;
			this.dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT_CHANGE));
		}
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
	
		/**
		 * Called when the layout container needs to layout its children.
		 */
		public function layoutObjects(displayObjects:Array, bounds:Rectangle):Rectangle
		{
			var selectedItem:DisplayObject;
			
			//loop through all the children and display only the child at the selected index
			var childCount:int = displayObjects.length;
			for(var i:int = 0; i < childCount; i++)
			{
				var child:DisplayObject = displayObjects[i] as DisplayObject;
				if(i == this.selectedIndex)
				{
					child.visible = true;
					child.x = bounds.x;
					child.y = bounds.y;
					selectedItem = child;
				}
				else
				{
					child.visible = false;
				}
			}
			
			//if there is a selected item, return its bounds
			if(selectedItem)
			{
				return new Rectangle(bounds.x, bounds.x, selectedItem.width, selectedItem.height);
			}
			
			//if selected index < 0 or > numChildren, just return the original bounds
			return bounds;
		}
	}
}