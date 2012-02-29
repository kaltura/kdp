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
	import com.kaltura.plugin.events.RestrictionErrorEvent;
	
	public class RestrictionString extends BaseRestriction
	{
		public static const TYPE:String = "string"
		/**
		* Indicates whether we should use enumeration to validate the string
		*/		
		protected var _bfRestrictEnum:Boolean = false;
		/**
		* _oEnumValues Associative array, stores the enumeration values of this RestrictionString object.
		* The validation succeeds only if the data source is one of the Strings stored in this Object.
		*/		
		protected var _oEnumValues:Array = new Array();
		/**
		 * Validates dataToCheck against each of the tests defined by setRestriction()
		 * @param dataToCheck
		 * @return true if the data passed the validation, false otherwise.
		 * 
		 */		
		public override function validateData(dataToCheck:*):Boolean
		{
			if (_bfRestrictEnum){
				return validateEnum(dataToCheck);
			//if this RestrictionString object only restricts data type 
			} else {
				return true;
			}
			
		}
		/**
		 * Sets this RestrictionString object set of restriction rules.
		 * The rules are defined by xmlRestriction XML object, which uses this format:
		 * 	
		 * @param xmlRestriction Defines a set of rules for validation and uses the following format:
		 *   <restriction type="string">
		 *     <enum value="right"/>
		 *     <enum value="left"/>
		 *   </restriction>
		 * 
		 */		
		public override function setRestriction(xmlRestriction:XML):void
		{
			super.setRestriction(xmlRestriction);
			//if this restriction xml element contains enumerations restriction
			if (xmlRestriction.enums.length() > 0){
				_bfRestrictEnum = true;
				var sValue:String;
				var i:int = 0;
				for each(var sEnum:String in xmlRestriction.enums.enum.@value)
				{
					_oEnumValues[sEnum] = i++;
				}
			}
		}
		/**
		 * 
		 * @param sDataToCehck
		 * @return true if sDataToCehck stored in _aEnumValues, otherwise false   
		 * 
		 */		
		protected function validateEnum(sDataToCehck:String):Boolean
		{
			if (_oEnumValues[sDataToCehck] !== undefined){
				return true;
			} else {
				dispatchEvent(new RestrictionErrorEvent(RestrictionErrorEvent.ENUM_ERROR));
				return false;
			}
		}
		public function get enumValues():Object
		{
			return _oEnumValues;
		}
		
		public override function getType():String
		{
			return TYPE;
		}
		
	}
}