/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.accessibility
{
	/**
	 * Constants for MSAA accessibility focus and selection flags available in Flash Player.
	 */
	public class FocusAndSelectionFlags
	{
		public static const SELFLAG_NONE:uint =                 0;
		public static const SELFLAG_TAKEFOCUS:uint =            1;
		public static const SELFLAG_TAKESELECTION:uint =        2;
		public static const SELFLAG_EXTENDSELECTION:uint =      4;
		public static const SELFLAG_ADDSELECTION:uint =         8;
		public static const SELFLAG_REMOVESELECTION:uint =      16;
	}
}