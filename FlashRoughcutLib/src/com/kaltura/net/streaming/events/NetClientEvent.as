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
package com.kaltura.net.streaming.events
{
	import flash.events.Event;

	public class NetClientEvent extends Event
	{
		public static var ON_METADATA_BUFFER_SIZES:String = "onMetadataBufferSizes";
		public static var ON_STREAM_END:String = "onStreamEnd";
		public static var ON_STREAM_SWITCH:String = "onStreamSwitch";
		public static var ON_LAST_SECOND:String = "onLastSecond";
		public static var ON_BANDWIDTH_CHECK_COMPLETE:String = "onBandwidthCheckComplete";

		public var data:*;

		public function NetClientEvent (event_type:String, data_value:*=null):void
		{
			super (event_type, true, true);
			data = data_value;
		}

		override public function clone():Event
		{
			return new NetClientEvent (type,data);
		}

	}
}