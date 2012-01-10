/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.example
{
	import com.yahoo.astra.layout.modes.ILayoutMode;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;

	/**
	 * A specialized layout that positions and sizes its children based on
	 * constraints. This algorithm requires that all children are instances of
	 * type ConstraintClient.
	 * 
	 * @see com.yahoo.example.ConstraintClient
	 * @author Josh Tynjala
	 */
	public class ConstraintLayout extends EventDispatcher implements ILayoutMode
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function ConstraintLayout()
		{
			super();
		}

	//--------------------------------------
	//  Public Methods
	//--------------------------------------
	
		/**
		 * @inheritDoc
		 */
		public function layoutObjects(displayObjects:Array, bounds:Rectangle):Rectangle
		{
			//loop through the children to update their position and size
			//based on the top, right, bottom, and left constraints
			
			var childCount:int = displayObjects.length;
			for(var i:int = 0; i < childCount; i++)
			{
				var child:ConstraintClient = displayObjects[i] as ConstraintClient;
				
				//ensure that the child is a ConstraintClient.
				if(!child)
				{
					
					throw new Error("ConstraintLayout requires that all children of displayObjects be of type ConstraintClient. Child " + displayObjects[i] + " is not compatible.");
					
					//alternatively, one could skip non-ConstraintClient
					//children if you'd like to allow other types of display
					//objects.
					
					//comment out the throw statement and uncomment the continue
					//statement to use this alternative behavior.
					
					//continue;
				}
				
				//set the x position and width
				if(!isNaN(child.left) && !isNaN(child.right))
				{
					//if both left and right are set, we need to alter both the
					//position and size
					child.x = bounds.x + child.left;
					child.width = bounds.width - child.left - child.right;
				}
				else if(!isNaN(child.left))
				{
					//if only left is set, position from the left edge
					child.x = bounds.x + child.left;
				}
				else if(!isNaN(child.right))
				{
					//if only right is set, position from the right edge
					child.x = bounds.x + bounds.width - child.right - child.width;
				}
				
				//set the y position and height
				if(!isNaN(child.top) && !isNaN(child.bottom))
				{
					//if both top and bottom are set, we need to alter both the
					//position and size
					child.y = bounds.y + child.top;
					child.height = bounds.height - child.top - child.bottom;
				}
				else if(!isNaN(child.top))
				{
					//if only top is set, position from the top edge
					child.y = bounds.y + child.top;
				}
				else if(!isNaN(child.right))
				{
					//if only bottom is set, position from the bottom edge
					child.y = bounds.y + bounds.height - child.bottom - child.height;
				}
			}
			
			//we're not changing the bounds, so just return the same value that was passed in
			return bounds;
		}
		
	}
}