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
package com.kaltura.plugin.utils.controls
{
	import com.kaltura.base.IDisposable;
	//xxx import com.kaltura.plugin.UI.componenets.IComponent;
	import com.kaltura.plugin.formats.ArgumentFormat;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	/**
	 * Fucntions as an abstract key index container for a collection of IProperty instances
	 *
	 */
	public dynamic class ControlsDictionary extends Dictionary implements IEventDispatcher, IDisposable
	{

		private var _oIdToComponent:Object;
		private var _dispatcher:EventDispatcher;

		/**
		 * creates new ControlsDictionary object
		 * @return
		 */
		public function ControlsDictionary(weakKeys:Boolean = false):void
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
			var xmlArguments:XML  = <arguments/>;
			var xmllArguments:XMLList;
/*xxx
			for each (var argument:IComponent in this)
			{
				var xmlComponentArguments:XML = argument.toXML();
				if (xmlComponentArguments) //the component may not implement a toXML() method
				{
					xmllArguments = argument.toXML().argument;
					xmlArguments.appendChild( xmllArguments);
				}

			}
xxx*/
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
//xxx			var comp:IComponent;
			var comps:Array;
			var sPropName:String;
			for each (var xmlProperty:XML in xmlProps.argument)
			{
/*xxx
				sPropName = ArgumentFormat.getID(xmlProperty);
				comps = _oIdToComponent[sPropName];
				for each (comp in comps)
				{
					comp.setValue(xmlProperty);
				}
xxx*/				
				/*  else {
					throw new Error("The property '" + sPropName + "' doesn't have a matching control object");
				} */
			}
		}
		/**
		 * An abstract method to be overriden by a method that resets each of the IProperty object
		 * stored in this ExDictionary object to its default value.
		 *
		 */
		public function resetToDefault():void
		{
/*xxx
			for each (var prop:IComponent in this)
			{
				prop.resetToDefault();
			}
xxx*/			
		}

		public function setIDsToComponent(oIdToComponent:Object):void
		{
			_oIdToComponent = oIdToComponent;
		}

		//IEventDispatcher methods
	    public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
	    {
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

	    public function dispose ():void
	    {
	    	_dispatcher = null;
	    	_oIdToComponent = null;
	    }
	}
}