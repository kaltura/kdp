/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.charts.series
{
	import com.yahoo.astra.fl.charts.legend.LegendItemData;
	
	/**
	 * A series type that can create data for a legend.
	 * 
	 * @see com.yahoo.astra.fl.charts.legend.ILegend
	 * @see com.yahoo.astra.fl.charts.legend.LegendItemData
	 * 
	 * @author Josh Tynjala
	 */
	public interface ILegendItemSeries extends ISeries
	{
		
	//--------------------------------------
	//  Methods
	//--------------------------------------
	
		/**
		 * Creates a LegendItemData object to pass to the chart's legend.
		 */
		function createLegendItemData():LegendItemData	
	}
}