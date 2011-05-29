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
package com.kaltura.roughcut.events
{
	import flash.events.Event;

	public class RoughcutChangeEvent extends Event
	{
		static public const ROUGHCUT_DURATION_CHANGE:String = "roughcutDurationChange";
		static public const ROUGHCUT_SOUNDTRACK_CHANGE:String = "roughcutSoundtrackChange";
		static public const ROUGHCUT_DIRTY:String = "roughcutDirty";
		static public const ROUGHCUT_MODIFIED:String = "roughcutModified";

		/**
		 *Constructor.
		 * @param type				type of the change event.
		 * @param bubbles			true for bubble.
		 * @param cancelable		true for enabling cancel of event.
		 */
		public function RoughcutChangeEvent (type:String, bubbles:Boolean=true, cancelable:Boolean=false):void
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new RoughcutChangeEvent (type, bubbles, cancelable);
		}
	}
}