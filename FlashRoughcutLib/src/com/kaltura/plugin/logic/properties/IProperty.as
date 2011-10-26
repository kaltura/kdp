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
	import com.kaltura.plugin.logic.properties.restrictions.BaseRestriction;
	
	public interface IProperty
	{
		/**
		 * Returns an XML representation of an IProperty instance
		 * @return 
		 * 
		 */		
		function toXML():XML;
		/**
		 * Sets component value from the value stored in the xmlArgument 
		 * @param xmlProp an XMl representation of a Property class instance value
		 * @see plugin.logic.properties.Property
		 */		
		function setValue(xmlArgument:XML, dispatchChange:Boolean = true):void;
		
		function get id():String;
		function set id(value:String):void;
		
		function setDefinition(restrcition:BaseRestriction):void;
		function resetToDefault():void;
 		/* function set restriction(restrictionObject:BaseRestriction):void;
		function get restriction():BaseRestriction; */
	}
}