/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.charts
{
	import com.yahoo.astra.fl.charts.series.StackedColumnSeries;
	
	/**
	 * A chart that displays its data points with vertical columns
	 * that are stacked vertically.
	 * 
	 * @author Josh Tynjala
	 */
	public class StackedColumnChart extends CartesianChart
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function StackedColumnChart()
		{
			super();
			this.defaultSeriesType = StackedColumnSeries;
		}
	}
}