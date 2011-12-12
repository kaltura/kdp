/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.charts.axes
{
	/**
	 * Scale types available to <code>IAxis</code> objects.
	 * 
	 * @author Josh Tynjala
	 */
	public class ScaleType
	{
		
	//--------------------------------------
	//  Constants
	//--------------------------------------
	
		/**
		 * The ScaleType.LINEAR constant specifies that chart axis objects
		 * should be displayed on a linear scale.
		 */
		public static const LINEAR:String = "linear";
		
		/**
		 * The ScaleType.LOGARITHMIC constant specifies that chart axis objects
		 * should be displayed on a logarithmic scale.
		 */
		public static const LOGARITHMIC:String = "logarithmic";
	}
}
