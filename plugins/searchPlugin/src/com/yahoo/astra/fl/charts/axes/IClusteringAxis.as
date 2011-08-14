/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.charts.axes
{
	/**
	 * An axis that supports clustering. When combined with a series that
	 * supports clustering, the number of clusters will allow the series to
	 * determine the optimal positioning of markers.
	 * 
	 * @author Josh Tynjala
	 */
	public interface IClusteringAxis extends IAxis
	{
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
		 * The number of clusters available on the axis. In the case of the
		 * CategoryAxis, this is the number of category names displayed on the
		 * axis.
		 * 
		 * @see CategoryAxis
		 */
		function get clusterCount():int;
	}
}