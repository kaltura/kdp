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
package com.kaltura.managers.downloadManagers.pluginManager.events
{
	import flash.events.Event;
	/**
	 * The ItemLoaderEvent class represents event objects that are specific to the ItemLoader class,
	 * such as the event that is dispatched when resources of a ManagerItem have been loaded.
	 * 
	 */
	public class PluginLoaderEvent extends Event
	{
		public static const XMLRESTRICTIONS_COMPLETE:String = "XMLRestrictionsComplete";
		public static const XMLUI_COMPLETE:String = "XMLUILoadComplete";
		public static const PLUGIN_INSTANCE_COMPLETE:String = "PluginInstanceComplete";
		
		public function PluginLoaderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new PluginLoaderEvent(type, bubbles, cancelable);
		}
	}
}