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
package com.kaltura.plugin.utils.fonts
{
	import flash.events.Event;

	public class FontManagerEvent extends Event
	{
		
		public static const COMPLETE:String = "complete";
		/**
		* Indicates that a font could not be cated to IFontModule
		*/		
		public static const INVALID_FONT:String = "invalidFont";
		private var _fontModule:IFontModule;
		public function FontManagerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, fontModule:IFontModule = null):void
		{
			super(type, bubbles, cancelable);
			_fontModule = fontModule;
		}
		public function get fontModule():IFontModule
		{
			return _fontModule;
		}
		public override function clone():Event
		{
			return new FontManagerEvent(type, bubbles, cancelable, _fontModule);
		}
		public override function toString():String
		{
			return formatToString("FontManagerEvent", "type", "bubbles", "cancelable", "eventPhase", "fontModule");
		}
	}
}