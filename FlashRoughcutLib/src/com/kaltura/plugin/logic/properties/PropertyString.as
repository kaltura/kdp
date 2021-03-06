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
package com.kaltura.plugin.logic.properties
{
	/**
	 * PropertyString is a concrete property (extends @see Property [Property]).
	 * It stores data concerning to this Property object like, mainly it's value.
	 * 
	 */	
	public class PropertyString extends Property
	{
		private var _sValue:String;
		/**
		 * @inheritDoc
		 */		
		public override function set value(newValue:*):void
		{
			_sValue = String(newValue);
			super.value = newValue;
		}

		public override function get value():*
		{
			return _sValue;
		}
	}
}