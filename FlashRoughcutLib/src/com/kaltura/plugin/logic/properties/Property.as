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
	import com.kaltura.plugin.formats.ArgumentFormat;
	import com.kaltura.plugin.logic.properties.restrictions.BaseRestriction;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Event(name="change", type="flash.events.Event")]
	public class Property extends EventDispatcher implements IProperty
	{

		protected var _sID:String;
		/**
		* This Plugin BaseRestriction Object.
		* Holds a sub class instance of BaseRestrcition, provides validation services.
		* @see plugin.logic.properties.restrictions.BaseRestriction
		*/
		protected var _Restriction:BaseRestriction
		/**
		* This plugin default value, if no other value was set.
		* A default value must be specified in the <property> element
		*/
		protected var _defaultValue:*;
		/**
		 * Sets this Property definitions.
		 * The definition are stored in an XML who's root element is <property>.
		 * The <property> element contains information about the Property like its type, id and restrictions
		 * @param xmlPropertyDef
		 *
		 */
		public function setDefinition(restriction:BaseRestriction):void
		{
			_sID = restriction.id;
			_Restriction = restriction;
			resetToDefault();
		}
		/**
		 * Resets this Property to its default value.
		 * Sets the value property to the _defaultValue;
		 */
		public function resetToDefault():void
		{
			value = _Restriction.defaultValue;
		}
		/**
		 * This Property instance's default value
		 * @return
		 *
		 */
		public function get defaultValue():*
		{
			return _defaultValue;
		}
		/**
		 * An abstract method to be overwritten by a concrete Property that implements a getter function of its value type
		 * @throws Error which indicates that an abstract method was invoked
		 *
		 */
		public function get value():*
		{
			throw new Error("Abstract class Property class has no value property");
		}
		/**
		 * sets this instance value if it's valid according to @see #_Restriction() [_Restriction() method]
		 * @param newValue
		 *
		 */
		public function set value(newValue:*):void
		{
			if (!isValid(newValue)){
				//throw new Error("Property object " +  _sID + ": The value that was set ('" + newValue + "') is invalid according to this Property's restrictions");
				trace ("WARNING: Property object " +  _sID + ": The value that was set ('" + newValue + "') is invalid according to this Property's restrictions");
				return;
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		/**
		 * Sets this Property's values according to the <property> element
		 * @param xmlProperty
		 *
		 */
		public function setValue(xmlProperty:XML, dispatchChange:Boolean = true):void
		{
			value = ArgumentFormat.getValue(xmlProperty);
		}
		/**
		 * Validates the current Property data according to this Property object BaseRestriction object
		 * @return
		 *
		 */
		public function isValid(dataToValidate:String):Boolean
		{
			return _Restriction.validateData(dataToValidate);
		}
		/**
		 * sets/gets this Property's unique id
		 * @return
		 *
		 */
		public function get id():String
		{
			return _sID;
		}
		public function set id(value:String):void
		{
			_sID = value;
		}

 		/**
 		 * toXML() method returns an xml representation of this Property object in the following form:
 		 * <property id="My id" value="My value"/>
 		 * @return an XML that represent an error, occured by accessing an abstract method
 		 *
 		 */
 		public function toXML():XML
		{
			return ArgumentFormat.toXML(_sID, value);
		}
		public function get restriction():BaseRestriction
		{
			return _Restriction;
		}

/*		public function set restriction(restrictionObject:BaseRestriction):void
		{
			_Restriction = restrictionObject;
		} */
	}
}