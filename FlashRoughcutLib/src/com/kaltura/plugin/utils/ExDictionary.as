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
package com.kaltura.plugin.utils
{
	import com.kaltura.plugin.logic.properties.IProperty;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	/**
	 * Fucntions as an abstract key index container for a collection of IProperty instances
	 *
	 */
	public dynamic class ExDictionary extends Dictionary implements IEventDispatcher
	{

		private var _dispatcher:EventDispatcher;

		/**
		 * creates new ExDictionary object
		 * @return
		 */
		public function ExDictionary(weakKeys:Boolean = false):void
		{
			super(weakKeys);
			_dispatcher = new EventDispatcher(this);
		}
		/**
		 * Returns an XMLListCollection containing this ExDictionary object's IProperty instances toXML() values
		 * @return
		 *
		 */
		public function toXML():XML
		{
			var xmlArguments:XML = <arguments/>;
			var xmlArgument:XML;

			for each (var argument:IProperty in this)
			{
				xmlArgument = argument.toXML();
				if (xmlArgument)
				{
					xmlArguments.appendChild( xmlArgument );
				}
			}

			return xmlArguments;
		}

		/**
		 * Takes an XML element that describes a Plugin class properties with the following form:
		 * <arguments>
		 * 	 <property id="acceleration" value="78.6" />
		 * 	 <property id="speed" value="100" />
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
				if (this[sPropName] != null)
				{
					IProperty(this[sPropName]).setValue(xmlProperty);
				} else {
					throw new Error("The IProperty '" + sPropName + "' doesn't exist in this ExDictionary object");
				}
			}
		}

		//IEventDispatcher methods

	    public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
	        _dispatcher.addEventListener(type, listener, useCapture, priority);
	    }

	    public function dispatchEvent(event:Event):Boolean
	    {
	        return _dispatcher.dispatchEvent(event);
	    }

	    public function hasEventListener(type:String):Boolean
	    {
	        return _dispatcher.hasEventListener(type);
	    }

	    public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
	    {
	        _dispatcher.removeEventListener(type, listener, useCapture);
	    }

	    public function willTrigger(type:String):Boolean
	    {
	        return _dispatcher.willTrigger(type);
	    }
	}
}