/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls.autoCompleteClasses {
import flash.text.TextFormat;
	
import fl.events.ComponentEvent;
import fl.core.InvalidationType;
import fl.controls.listClasses.CellRenderer;
import fl.core.UIComponent;
//--------------------------------------
//  Class description
//--------------------------------------
/**
 * The AutoCompleteCellRenderer is the default cell renderer for AutoComplete, 
 * adding support for highlighted items.
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 * @see com.yahoo.astra.fl.controls.AutoComplete
 */	
public class AutoCompleteCellRenderer extends CellRenderer
{
	public function AutoCompleteCellRenderer() 
	{
		super();
		super.drawTextFormat();
	}
		
		
		/**
         * @private (protected)
         *
		 */
		override protected function drawTextFormat():void 
		{
			//overrides highlighted text if emphasizeMatch is true
		}
}
}