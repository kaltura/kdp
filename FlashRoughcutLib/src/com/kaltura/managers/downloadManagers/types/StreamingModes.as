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
package com.kaltura.managers.downloadManagers.types
{
	/**
	 * types used to determine what method of serving media source to use.
	 */
	public class StreamingModes
	{
		static public const PROGRESSIVE:int = 0;
		static public const PROGRESSIVE_STREAM_SINGLE:int = 1;				//discrete streams method - single stream for each mediaType
		static public const PROGRESSIVE_STREAM_DUAL:int = 2;				//discrete streams method - two streams for each mediaType
		static public const STREAMING_MEDIA_SERVER:int = 3;
		static public const BITMAP_SOCKET:int = 4;							//use a bitmap socket server (for flattening).
	}
}