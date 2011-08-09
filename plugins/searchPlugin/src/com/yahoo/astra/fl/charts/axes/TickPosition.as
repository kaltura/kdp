/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.charts.axes
{
	/**
	 * Position values available to axis ticks.
	 * 
	 * @author Josh Tynjala
	 */
	public class TickPosition
	{
		
	//--------------------------------------
	//  Constants
	//--------------------------------------
	
		/**
		 * The TickPosition.OUTSIDE constant specifies that chart axis ticks
		 * should be displayed on the outside of the axis.
		 */
		public static const OUTSIDE:String = "outside";
		
		/**
		 * The TickPosition.INSIDE constant specifies display of chart axis
		 * ticks should be displayed on the inside of the axis.
		 */
		public static const INSIDE:String = "inside";
		
		/**
		 * The TickPosition.CROSS constant specifies display of chart axis ticks
		 * should be displayed crossing the axis.
		 */
		public static const CROSS:String = "cross";
	}
}
