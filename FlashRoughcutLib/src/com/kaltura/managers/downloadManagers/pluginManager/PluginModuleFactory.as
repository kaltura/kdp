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
	import com.kaltura.managers.downloadManagers.pluginManager.events.PluginFactoryEvent;
	import com.kaltura.net.interfaces.ILoadableObject;
	import com.kaltura.net.interfaces.IMediaSource;
	//import com.kaltura.plugin.UI.PluginUI;
	//import com.kaltura.plugin.events.PluginUIEvent;
	import com.kaltura.plugin.logic.Plugin;
	import com.kaltura.plugin.logic.properties.restrictions.Restrictions;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	[Event(name="logicInit", type="plugin.events.PluginManagerEvent")]
	public class PluginModuleFactory extends EventDispatcher implements ILoadableObject
	{

		/**
		 * This ManagerItem's PluginUI object.
		 * instantiation only once per plugin
		 */
		//xxx private var _pluginUI:PluginUI;

		/**
		 * This ManagerItem's Restrictions object.
		 * instantiation only once per plugin
		 */
		private var _restrictions:Restrictions;

		/**
		* An array that holds a list of bindable names to be passed to the Plugin class objects
		* A bind name, is an identifier of the corresponding object that uses the Plugin instance.
		* The bind names needs to be accumulated because more than one request for a plugin can be made during the loading of the
		* needed resource (xml definition file, swf module).
		* each such request is made with createLogicPlugin() method, contains a bind name that should be stored for a later initialization.
		*/
		private var _aBindNames:Array = new Array();

		/**
		* A reference-like counter that enables a delayed initialization of Plugin instances.
		* Such delayed initialization is needed beacuse more than one request for a plugin can be made during the loading of the
		* needed resource (xml definition file, swf module).
		*/
		private var _nInstancesToInit:uint = 0;

		private var _pluginLoader:PluginModuleLoader;

		private var _bPluginLoaded:Boolean = false;

		public function PluginModuleFactory(module_url:String, plugin_uid:String):void
		{
			_pluginLoader = new PluginModuleLoader(module_url, plugin_uid);
			_restrictions = new Restrictions();
		}

		public function get pluginLoader ():PluginModuleLoader
		{
			return _pluginLoader;
		}

		/**
		 *Loads this ManagerItem restrictions XML definition file.
		 * @param loadingMode		load the plugin in player or editor mode.
		 * @return 					the pluginModuleLoader instance that monitor the plugin creation and it's instantiation.
		 *
		 */
		public function load(loadingMode:String):PluginModuleLoader
		{
			_pluginLoader.addEventListener(Event.COMPLETE, buildPluginResources);
			_pluginLoader.load(loadingMode);
			return _pluginLoader;
		}

		/**
		 * Instantiates PluginUI, the Restrictions classes and sets this ManagerItem _logicModuleInfo.
		 * Invoked when the ItemLoader has dispatched an Event.COMPLETE event
		 * Dispatches a PluginManagerEvent.LOGIC_LOADED to indicates that the Plugin can be instantiated.
		 * @param evtComplete
		 */
		private function buildPluginResources(evtComplete:Event):void
		{
			_bPluginLoaded = true;
			var loader:PluginModuleLoader = PluginModuleLoader(evtComplete.target);
			_restrictions.setDefinitions(loader.restrictionsDefinition);

			if (loader.loadingMode == PluginLoadingModes.EDITOR_MODE && loader.UIDefinition.UI[0])
			{
				//xxx _pluginUI = new PluginUI();
				//_pluginUI.setDefinition(loader.UIDefinition, _restrictions);
			}
			dispatchEvent(new PluginFactoryEvent(PluginFactoryEvent.LOGIC_LOADED));
		}

		/**
		 * Plugin class instance instantiation function.
		 * after the plugin is instantiated, the ManagerItem object dispatches a PluginManagerEvent.LOGIC_INIT event
		 * @param sBindTo The Plugin instance bind name (it's matching target name)
		 *
		 */
		public function requestLogicPlugin(asset_uid:String):void
		{
			_aBindNames.push(asset_uid);
			_nInstancesToInit++;

			if (_bPluginLoaded)
				initLogicInstance(null);
			else
				addEventListener(PluginFactoryEvent.LOGIC_LOADED, initLogicInstance);
		}

		/**
		 * Instantinates one or more Plugin instances and dispatches a PluginManagerEvent.LOGIC_INIT event for each instantiation.
		 * The _nInstancesToInit indicates how many instances should be created and may be greater than 1 only on the first time the
		 * initLogicInstance() is called, that may happen if requested for createLogicPlugin() were made while the resoucres needed to
		 * make the Plugin instance were not ready. These resources are mainly the XML definition file and the SWF moudle. also
		 * @param evtLogicReady
		 *
		 */
		private function initLogicInstance(evtLogicLoaded:PluginFactoryEvent):void
		{
			for (_nInstancesToInit; _nInstancesToInit > 0; _nInstancesToInit--)
			{
				var logicInstance:Plugin = _pluginLoader.getLogicInstance ();
				if (logicInstance)
				{
					//xxx logicInstance.ui = _pluginUI;
					//for single overlay and ui, this can be used. otherwise, the application layer should handle this, because there is one ui for N overlays of the same type X.
					//_pluginUI.addEventListener(PluginUIEvent.UI_APPLY, logicInstance.handleChangePluginUiArguments, false, 0, true);
					logicInstance.setDefinition(_restrictions);
					var bindName:String = _aBindNames.shift();
					dispatchEvent(new PluginFactoryEvent(PluginFactoryEvent.LOGIC_INIT, logicInstance, bindName));
				}
			}

		}

		/**
		 * This ManagerItem's PluginUI instance
		 * @return
		 *
		 */
/* 		public function get ui():PluginUI
		{
			return _pluginUI;
		}
 */
		public function get restrictions():Restrictions
		{
			return _restrictions;
		}

		public function get bytesLoaded ():uint
		{
			return _pluginLoader.bytesLoaded;
		}

		public function get bytesTotal ():uint
		{
			return _pluginLoader.bytesTotal;
		}

		public function get mediaSource ():IMediaSource
		{
			return null;
		}

		/**
		 *disposes of the object from memory.
		 */
		public function dispose ():void
		{
			if (_restrictions)
				_restrictions.clear();
			_restrictions = null;
/* 			if (_pluginUI)
				_pluginUI.dispose();
			_pluginUI = null;
 */			_aBindNames = null;
			_pluginLoader.dispose ();
		}
	}
}