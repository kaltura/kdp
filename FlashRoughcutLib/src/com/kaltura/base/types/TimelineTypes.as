/*
This file is part of the Kaltura Collaborative Media Suite which allows users
to do with audio, video, and animation what Wiki platfroms allow them to do with
text.

Copyright (C) 2006-2008  Kaltura Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

@ignore
*/
package com.kaltura.base.types
{
	/**
	 *Constants for deciding which types of timelines should be loaded on a show...
	 */
	public class TimelineTypes
	{
		static public var ANY_TIMELINE:uint = 0xffffffff;
		static public var VIDEO:uint = 0x2;
		static public var AUDIO:uint = 0x4;
		static public var OVERLAYS:uint = 0x8;
		static public var EFFECTS:uint = 0x10;
		static public var TRANSITIONS:uint = 0x20;
	}
}