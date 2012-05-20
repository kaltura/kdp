/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.containers
{	
	/**
	 * A scrolling container that arranges its children in a vertical column.
	 * 
	 * @example The following code configures a VBoxPane container:
	 * <listing version="3.0">
	 * var pane:VBoxPane = new VBoxPane();
	 * pane.verticalGap = 4;
	 * pane.verticalAlign = VerticalAlignment.MIDDLE;
	 * this.addChild( pane );
	 * </listing>
	 * @see com.yahoo.astra.layout.modes.BoxLayout
	 * @author Josh Tynjala
	 */
	public class VBoxPane extends BoxPane
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 * 
		 * @param configuration		An Array of optional configurations for the layout container's children.
		 */
		public function VBoxPane(configuration:Array = null)
		{
			super(configuration);
			this.direction = "vertical";
		}
	}
}