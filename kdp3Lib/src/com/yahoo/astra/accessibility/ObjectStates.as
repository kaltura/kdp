/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.accessibility
{
	/**
	 * Constants for MSAA accessibility states available in Flash Player.
	 */
	public class ObjectStates
	{
		public static const STATE_SYSTEM_NORMAL:uint =             0x00000000;
		public static const STATE_SYSTEM_UNAVAILABLE:uint =        0x00000001;
		public static const STATE_SYSTEM_SELECTED:uint =           0x00000002;
		public static const STATE_SYSTEM_FOCUSED:uint =            0x00000004;
		public static const STATE_SYSTEM_PRESSED:uint =            0x00000008;
		public static const STATE_SYSTEM_CHECKED:uint =            0x00000010;
		public static const STATE_SYSTEM_MIXED:uint =              0x00000020;
		public static const STATE_SYSTEM_READONLY:uint =           0x00000040;
		public static const STATE_SYSTEM_HOTTRACKED:uint =         0x00000080;
		public static const STATE_SYSTEM_DEFAULT:uint =            0x00000100;
		public static const STATE_SYSTEM_EXPANDED:uint =           0x00000200;
		public static const STATE_SYSTEM_COLLAPSED:uint =          0x00000400;
		public static const STATE_SYSTEM_BUSY:uint =               0x00000800;
		public static const STATE_SYSTEM_FLOATING:uint =           0x00001000;
		public static const STATE_SYSTEM_MARQUEED:uint =           0x00002000;
		public static const STATE_SYSTEM_ANIMATED:uint =           0x00004000;
		public static const STATE_SYSTEM_INVISIBLE:uint =          0x00008000;
		public static const STATE_SYSTEM_OFFSCREEN:uint =          0x00010000;
		public static const STATE_SYSTEM_SIZEABLE:uint =           0x00020000;
		public static const STATE_SYSTEM_MOVEABLE:uint =           0x00040000;
		public static const STATE_SYSTEM_SELFVOICING:uint =        0x00080000;
		public static const STATE_SYSTEM_FOCUSABLE:uint =          0x00100000;
		public static const STATE_SYSTEM_SELECTABLE:uint =         0x00200000;
		public static const STATE_SYSTEM_LINKED:uint =             0x00400000;
		public static const STATE_SYSTEM_TRAVERSED:uint =          0x00800000;
		public static const STATE_SYSTEM_MULTISELECTABLE:uint =    0x01000000;
		public static const STATE_SYSTEM_EXTSELECTABLE:uint =      0x02000000;
		public static const STATE_SYSTEM_ALERT_LOW:uint =          0x04000000;
		public static const STATE_SYSTEM_ALERT_MEDIUM:uint =       0x08000000;
		public static const STATE_SYSTEM_ALERT_HIGH:uint =         0x10000000;
		public static const STATE_SYSTEM_VALID:uint =              0x1FFFFFFF;
		public static const STATE_SYSTEM_HASPOPUP:uint =           0x40000000;
	}
}