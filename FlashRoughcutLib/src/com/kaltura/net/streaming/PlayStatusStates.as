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
package com.kaltura.net.streaming
{
	public class PlayStatusStates
	{
		public static const PLAY			:uint 		= 1;
		public static const PAUSE			:uint 		= 2;
		public static const STOP			:uint 		= 3;
		public static const PUBLISH			:uint 		= 4;
		public static const FLUSHING		:uint 		= 5;
		public static const BUFFERING		:uint 		= 6;
		public static const END_OF_SEGMENT	:uint 		= 4;

	}
}