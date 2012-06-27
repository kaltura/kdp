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

	public class ExNetStreamEvent extends Event
	{
		public static const REACHED_END_PART_OF_STREAM:String = "reachedEndPartOfStream";
		public static const STREAM_PLAYHEAD:String = "streamPlayhead";
		public static const FIXED_SEEK_TIME_TO_KEYFRAME:String = "fixedSeekTimeToKeyframe";
		public static const ON_STREAM_END:String = "onStreamEnd";
		public static const STREAM_READY:String = "streamReady";
		public static const GOT_STREAM_DURATION:String = "gotStreamDuration";
		public static const INVALID_SEEK_TIME:String = "invalidSeekTime";

		public var StreamName:String = "";
		public var playHeadTime:Number;
		public var originalSeekTime:Number;

		public function ExNetStreamEvent(type:String, nameOfStream:String, _playHeadTime:Number, _originalSeekTime:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			StreamName = nameOfStream;
			playHeadTime = _playHeadTime;
			originalSeekTime = _originalSeekTime;
			super(type, bubbles, cancelable);
		}

	}
}