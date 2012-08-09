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
package com.kaltura.managers.downloadManagers.pluginManager
{
	import com.kaltura.dataStructures.HashMap;
	import com.kaltura.dataStructures.IMap;
	import com.kaltura.managers.downloadManagers.pluginManager.events.PluginFactoryEvent;

	import flash.events.EventDispatcher;
	import flash.system.Security;

	[Event(name="logicInit", type="com.kaltura.managers.downloadManagers.pluginManager.events.PluginFactoryEvent")]

	/**
	 * Singleton manager class that provides Plugin loading and instantiation services.
	 */
	public class PluginMultiton extends EventDispatcher
	{
		/**
		* a single instance of the PluginManager class.
		*/
		protected static var instance:PluginMultiton = new PluginMultiton ();

		/**
		* A hash table that holds all the loaded Plugins, where each record in the table is ManagerItem object.
		*/
		protected var _table:IMap = new HashMap();

		/**
		 * Creates new PluginManager.
		 * Since PluginManager is a singleton class, it can only be instantiated once by the getInstance() method.
		 */
		public function PluginMultiton():void
		{
			//singleton check
			if( instance )
			{
				throw new Error( "PluginManager can only be accessed through PluginManager.getInstance()" );
			} else {
			 	Security.allowDomain("*");
			}
		}

		/**
		 * getInstance method for the singleton.
		 * @return the only instance of this class.
		 *
		 */
		public static function getInstance():PluginMultiton
		{
			return instance;
		}

		/**
		 *Creates a new Plugin class instance according to the sName.
		 * to create the new instance, the createPlugin retrieves the matching ManagerItem and calls its createLogicPlugin() method passing it a bind name.
		 * The object that call the createPlugin() method can recive the created Plugin instance by listening to the PluginManagerEvent.LOGIC_INIT event
		 * and use its pluginInstance property.
		 * @param base_url			the base folder of the module type to load.
		 * @param plugin_uid		the name of the folder and of the plugin module (*swf) to load.
		 * @param uid				a unique identifier of the asset to which we will append the loaded module.
		 * @param loadingMode		we load this plugin for player (don't load UI) or editing (with UI).
		 */
		public function create(base_url:String, plugin_uid:String, uid:String, loadingMode:String):PluginModuleFactory
		{
			/*check if the plugin is available (also check if the plugin is being created)*/
			var pluginUrl:String = base_url + plugin_uid + "/";
			var moduleFactory:PluginModuleFactory = _table.getValue(pluginUrl);

			if ( !moduleFactory )
			{
				moduleFactory = new PluginModuleFactory (pluginUrl, plugin_uid);
				moduleFactory.load(loadingMode);
				_table.setValue( pluginUrl, moduleFactory );
			}

			moduleFactory.addEventListener(PluginFactoryEvent.LOGIC_INIT, bubbleItemEvents)
			moduleFactory.requestLogicPlugin(uid);

			return moduleFactory;
		}

		/**
		 * Dispatches (bubbles) PluginManagerEvent.LOGIC_INIT events that were dispatched from a
		 * ManagerItem object any function that is registered with that event
		 * @param evtLogicInit
		 */
		protected function bubbleItemEvents(evtLogicInit:PluginFactoryEvent):void
		{
			dispatchEvent(evtLogicInit.clone());
		}
	}
}