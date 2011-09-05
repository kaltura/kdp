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
package com.kaltura.plugin.logic.properties.restrictions
{
	import com.kaltura.plugin.logic.properties.Property;
	
	import flash.events.EventDispatcher;
	/**
	 * BaseRestriction class is the an abstract class which is the base for all custom data validators
	 * like NumberValidator and StringValidator. 
	 * The BaseRestriction uses two methods: setRestriction() and validateData().
	 * The setRestriction() method should be called only one time, before using validateData(),
	 * in order to set the concrete validator restrictions.
	 * after the restrictions are set, any type can be passed to validateData() which returns a Boolean,
	 * indicating whether the data is valid or not.
	 * This class extends 
	 * 
	 */	
	public class BaseRestriction extends EventDispatcher
	{
		protected var _property:Property;
		protected var _sID:String;
		protected var _defaultValue:*;
		/**
		 * Validates the data returned from _DataToCheck getter method according to this concrete Restricitions set of rules
		 * passed by the setRestriction() method
		 * Not implemented in BaseRestriction.
		 * @return 
		 */		
		public function validateData(dataToCheck:*):Boolean
		{
			throw new Error("class BaseRestriction is an abstract class and therefore does not implement a validateData() method" );
		}
		/**
		 * Sets this concrete Restriction instance restrictions rules.
		 * Not implemented in BaseRestriction.
		 * @param xmlRestriction
		 * 
		 */		
		public function setRestriction(xmlRestriction:XML):void
		{
			_sID = xmlRestriction.id.text();
			_defaultValue = xmlRestriction.@default[0];
		}
		public function get id():String
		{
			return _sID;
		}
		public function get defaultValue():*
		{
			return _defaultValue;
		}
		public function set defaultValue(newDefaultValue:*):void
		{
			if ( validateData(newDefaultValue) )
			{
				_defaultValue = newDefaultValue;
			}
		}
		public function getType():String
		{
			throw new Error("BaseRestriction is an abstract class and do not implement a getType() method");
		}
	}
}