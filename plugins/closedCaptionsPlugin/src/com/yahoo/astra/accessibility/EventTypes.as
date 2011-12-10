/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.accessibility
{
	/**
	 * Constants for MSAA accessibility event types available in Flash Player.
	 */
	public class EventTypes
	{
		public static const EVENT_OBJECT_ACCELERATORCHANGE:uint =  0x00008012;
		public static const EVENT_OBJECT_CREATE:uint =             0x00008000;
		public static const EVENT_OBJECT_DESTROY:uint =            0x00008001;
		public static const EVENT_OBJECT_SHOW:uint =               0x00008002;
		public static const EVENT_OBJECT_HIDE:uint =               0x00008003;
		public static const EVENT_OBJECT_REORDER:uint =            0x00008004;
		public static const EVENT_OBJECT_FOCUS:uint =              0x00008005;
		public static const EVENT_OBJECT_SELECTION:uint =          0x00008006;
		public static const EVENT_OBJECT_SELECTIONADD:uint =       0x00008007;
		public static const EVENT_OBJECT_SELECTIONREMOVE:uint =    0x00008008;
		public static const EVENT_OBJECT_SELECTIONWITHIN:uint =    0x00008009;
		public static const EVENT_OBJECT_STATECHANGE:uint =        0x0000800a;
		public static const EVENT_OBJECT_LOCATIONCHANGE:uint =     0x0000800b;
		public static const EVENT_OBJECT_NAMECHANGE:uint =         0x0000800c;
		public static const EVENT_OBJECT_DESCRIPTIONCHANGE:uint =  0x0000800d;
		public static const EVENT_OBJECT_VALUECHANGE:uint =        0x0000800e;
		public static const EVENT_OBJECT_PARENTCHANGE:uint =       0x0000800f;
		public static const EVENT_OBJECT_HELPCHANGE:uint =         0x00008010;
		public static const EVENT_OBJECT_DEFACTIONCHANGE:uint =    0x00008011;
		public static const EVENT_OBJECT_MENUPOPUPSTART:uint =     0x00000006;
		public static const EVENT_OBJECT_MENUPOPUPEND:uint =       0x00000007;
		public static const EVENT_OBJECT_DIALOGSTART:uint =        0x0010;		
		public static const EVENT_OBJECT_DIALOGEND:uint =          0x0011;
	}
}