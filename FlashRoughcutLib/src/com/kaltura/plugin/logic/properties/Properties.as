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
	import com.kaltura.plugin.logic.properties.restrictions.Restrictions;
	
	import flash.events.EventDispatcher;
	/**
	 * Property objects container which provides acccess by key 
	 * 
	 */	
	public dynamic class Properties extends EventDispatcher
	{

		/**
		 * Returns an XML representation of this Properties object
		 * @return 
		 * 
		 */			
		public function toXML():XML
		{
			var xmlArguments:XML  = <arguments/>
			var xmlArgument:XML;
			
			for each (var argument:IProperty in this)
			{
				xmlArgument = argument.toXML();
				if (xmlArgument){
					xmlArguments.appendChild( xmlArgument );
				}
			}
			
			return xmlArguments;
		}
		
		/**
		 * Takes an XML element that describes a Properties object with the following form:
		 * <arguments>
		 * 	 <argument id="acceleration" value="78.6" />
		 * 	 <argument id="speed" value="100" />
		 *   .
		 *   .
		 *   .
		 * </arguments>
		 * 
		 * Each <property.../> element's "value" attribute is copied to its corresponding IProperty object if it's stored in this
		 * Properties object.
		 * @param xmlProps
		 * 
		 */	
		public function setProperties(xmlProps:XML):void
		{
			for each (var xmlProperty:XML in xmlProps.argument)
			{
				var sPropName:String = xmlProperty.@id;
				if (this[sPropName] != null){
					IProperty(this[sPropName]).setValue(xmlProperty);
				} else {
					throw new Error("The IProperty '" + sPropName + "' doesn't exist in this ExDictionary object");
				}
			}
		}
		
		
		
		/**
		 * Initializes all Property instances this Properties object holds
		 * @param xmlPropsDef
		 * 
		 */		
		 
		public function setDefinition(restrictions:Restrictions):void
		{
			var sPropName:String;
			for each (var restriction:BaseRestriction in restrictions)
			{
				var newProp:Property = PropertyFactory.create(restriction.getType());
				newProp.setDefinition(restriction);
				this[newProp.id] = newProp;
			}

		}
		/**
		 * Resets each of the Property objects stored in this Properties object to its default value.
		 */	
		public function resetToDefault():void
		{
			 for each (var prop:Property in this)
			{
				prop.resetToDefault();
			}
		} 
	}
}