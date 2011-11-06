/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.charts
{
	import com.yahoo.astra.fl.charts.axes.IAxis;
	import com.yahoo.astra.fl.charts.axes.IStackingAxis;
	import com.yahoo.astra.fl.charts.series.ISeries;
	import com.yahoo.astra.fl.charts.series.IStackedSeries;
	import com.yahoo.astra.fl.utils.UIComponentUtil;
	
	/**
	 * Utility functions used throughout the charting framework.
	 * 
	 * @author Josh Tynjala
	 */
	public class ChartUtil
	{
		
	//--------------------------------------
	//  Public Static Methods
	//--------------------------------------
	
		/**
		 * Determines if a series may be stacked on an axis. The series must
		 * implement the IStackedSeries type, the axis must implement the
		 * IStackingAxis type and the axis must have stackingEnabled set to
		 * true.
		 */
		public static function isStackingAllowed(axis:IAxis, series:ISeries):Boolean
		{
			return (series is IStackedSeries) && (axis is IStackingAxis) && IStackingAxis(axis).stackingEnabled;
		}
		
		/**
		 * Retreives every the series of the same type of the input series from the
		 * chart's data provider.
		 */
		public static function findSeriesOfType(series:ISeries, chart:IChart):Array
		{
			var type:Class = UIComponentUtil.getClassDefinition(series);
			var filteredSeries:Array = chart.dataProvider.filter(function(item:ISeries, index:int, source:Array):Boolean
			{
				var itemType:Class = UIComponentUtil.getClassDefinition(item);
				return itemType == type;
			});
			return filteredSeries;
		}

	}
}