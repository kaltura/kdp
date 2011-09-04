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
	import com.kaltura.plugin.logic.Plugin;
	
	import flash.events.Event;

	public class PluginFactoryEvent extends Event
	{
		public static const LOGIC_LOADED:String = "logicLoaded";
		public static const LOGIC_INIT:String = "logicInit";
		
		public var plugin:Plugin;
		public var uid:String;
		
		public function PluginFactoryEvent(type:String, asset_plugin:Plugin = null, asset_uid:String = "", bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
			plugin = asset_plugin;
			uid = asset_uid;
		}
		
		public override function clone():Event
		{
			return new PluginFactoryEvent(type, plugin, uid, bubbles, cancelable);
		}
	}
}