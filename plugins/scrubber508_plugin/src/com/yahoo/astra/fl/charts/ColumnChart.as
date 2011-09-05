/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.charts
{
	import com.yahoo.astra.fl.charts.series.ColumnSeries;
	
	/**
	 * A chart that displays its data points with vertical columns.
	 * 
	 * @author Josh Tynjala
	 */
	public class ColumnChart extends CartesianChart
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function ColumnChart()
		{
			super();
			this.defaultSeriesType = ColumnSeries;
		}
		
	}
}
