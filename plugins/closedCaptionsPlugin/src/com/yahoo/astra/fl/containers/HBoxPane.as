/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.containers
{
	/**
	 * A scrolling container that arranges its children in a horizontal row.
	 * 
	 * @example The following code configures an HBoxPane container:
	 * <listing version="3.0">
	 * var pane:HBoxPane = new HBoxPane();
	 * pane.horizontalGap = 4;
	 * pane.horizontalAlign = HorizontalAlignment.CENTER;
	 * this.addChild( pane );
	 * </listing>
	 * @see com.yahoo.astra.layout.modes.BoxLayout
	 * @author Josh Tynjala
	 */
	public class HBoxPane extends BoxPane
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 * 
		 * @param configuration		An Array of optional configurations for the layout container's children.
		 */
		public function HBoxPane(configuration:Array = null)
		{
			super(configuration);
			this.direction = "horizontal";
		}
		
	}
}