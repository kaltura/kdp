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
	 * PropertyFactory creates object of type Property that reference to a concrete property
	 * of instance the given type
	 * Implements a factory method pattern to perform the above action.
	 */
	public class PropertyFactory
	{
		public static function create(sPropType:String):Property
		{
			var prop:Property;
			switch(sPropType){
				case PropertyTypes.PropertyNumber:
					prop = new PropertyNumber();
					break;
				case PropertyTypes.PropertyString:
					prop = new PropertyString();
					break;
				case PropertyTypes.PropertyUint:
					prop = new PropertyUint();
					break;
				default:
					throw new Error("PropertyFactory class doesn't support the passed type '" + sPropType + "'");
					break;
			}
			return prop;
		}
	}
}