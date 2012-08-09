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
package com.kaltura.plugin.events
{
	import flash.events.Event;

	public class RestrictionErrorEvent extends Event
	{
		public static const STEP_ERROR:String = "stepError";
		public static const OUT_RANGE:String = "outOfRange";
		public static const NOT_A_NUMBER:String = "notANumber";
		public static const ENUM_ERROR:String = "enumError";
		public static const WRONG_TYPE:String = "wrongType";
		
		protected var _correctValue:* = null;
		
		public function RestrictionErrorEvent(type:String, correctVal:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			correctValue = correctVal;
		}
		/**
		 * correctValue is an extra property that allows the UI to get a corrected value
		 * as a reponse to a wrong user input. especially usefull to correct wrong numeric inputs that
		 * uses a stepSize restriction. 
		 * @return 
		 * 
		 */		
		public function get correctValue():*
		{
			return _correctValue;
		}
		public function set correctValue(correctVal:*):void
		{
			_correctValue = correctVal;
		}
		public override function clone():Event
		{
			return new RestrictionErrorEvent(type, correctValue, bubbles, cancelable);
		}
		public override function toString():String
		{
			return formatToString("RestrictionEvent", "correctValue", "type", "bubbles", "cancelable", "eventPhase", "URL"); 
		}
	}
}