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
	import com.kaltura.base.IDisposable;
	import com.kaltura.managers.downloadManagers.pluginManager.events.PluginLoaderEvent;
	import com.kaltura.plugin.logic.Plugin;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	import mx.utils.ObjectUtil;
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="XMLRestrictionsComplete", 		type="com.kaltura.managers.downloadManagers.pluginManager.events.PluginLoaderEvent")]
	[Event(name="PluginInstanceComplete",  		type="com.kaltura.managers.downloadManagers.pluginManager.events.PluginLoaderEvent")]
	[Event(name="XMLUILoadComplete", 			type="com.kaltura.managers.downloadManagers.pluginManager.events.PluginLoaderEvent")]

	public class PluginModuleLoader extends EventDispatcher implements IDisposable
	{
		//protected var moduleInfo:IModuleInfo;

		protected var _moduleURL:String;
		protected var _pluginUid:String;

		protected var _xmlRestrictions:XML;
		protected var _xmlUIDefinition:XML;

		private var _bytesTotal:Number = 0;
		private var _bytesLoaded:Number = 0;

		/**
		* Loading mode, a PluginManagerLoadingMode string type that indicates which files should be loaded.
		* For instance, if the mode is set to PluginManagerLoadingMode.PLAYER_MODE, no UI related files are being loaded because
		* the UI only has a meaning in the editor.
		*/
		protected var _sLoadingMode:String;

		/**
		 * Creates new Manager Item passing it a name and a url.
		 * @param 		asset_uid  			a unique identifier of the attached asset.
		 * @param 		plugin_uid			the name of the folder and of the plugin module (*swf) to load.
		 */
		public function PluginModuleLoader(module_url:String, plugin_uid:String):void
		{
			_pluginUid = plugin_uid;
			_moduleURL = module_url;
		}

		/**
		 * Triggers a series of actionsc starting from loading the restrictions.xml file,
		 * following ui.xml/ui.swf and then logic.swf
		 * @param loadingMode
		 *
		 */
		public function load(loadingMode:String):void
		{
			_sLoadingMode = loadingMode;
			var ldrRestrictions:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(_moduleURL + "restrictions.xml");
			ldrRestrictions.addEventListener(Event.COMPLETE, parseRestrictions);
			ldrRestrictions.addEventListener(IOErrorEvent.IO_ERROR, catchIOErrors);
			ldrRestrictions.addEventListener(SecurityErrorEvent.SECURITY_ERROR, catchSecurityErrors);
			ldrRestrictions.load(request);
		}

		/**
		 * catches XML definition IO loading error
		 * @param evtIOError
		 *
		 */
		private function catchIOErrors(evtIOError:IOErrorEvent):void
		{
			trace (ObjectUtil.toString(evtIOError));
		}

		/**
		 * catches XML definition security security loading errors
		 * @param evtModuleError
		 *
		 */
		private function catchSecurityErrors(evtSecureError:SecurityErrorEvent):void
		{
			throw evtSecureError;
		}

		/**
		 * Parses the loaded restrictions XML file and dispatches
		 * a ItemLoaderEvent.RESTRICTIONS_LOADED attached with the restrictions xml file.
		 * @param evtComplete
		 *
		 */
		private function parseRestrictions(evtComplete:Event):void
		{
 			var sXML:String = URLLoader(evtComplete.target).data;
			_xmlRestrictions = new XML(sXML);
			//if this plugin has restrictions
			if (_xmlRestrictions.restrictions[0]){
				dispatchEvent(new PluginLoaderEvent(PluginLoaderEvent.XMLRESTRICTIONS_COMPLETE));
			}

			switch (_sLoadingMode)
			{
				case PluginLoadingModes.EDITOR_MODE:
					loadUIDefinition();
					break;

				case PluginLoadingModes.PLAYER_MODE:
					loadPluginModule();
					break;
			}
		}

		private function loadUIDefinition():void
		{
			var ldrUIDefinition:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(_moduleURL + "ui.xml");
			ldrUIDefinition.addEventListener(IOErrorEvent.IO_ERROR, catchIOErrors);
			ldrUIDefinition.addEventListener(SecurityErrorEvent.SECURITY_ERROR, catchSecurityErrors);
			ldrUIDefinition.addEventListener(Event.COMPLETE, saveUiDefinition);
			ldrUIDefinition.load(request);
		}

		private function saveUiDefinition(evtComplete:Event):void
		{
			var sUIDefinition:String = URLLoader(evtComplete.target).data;
			_xmlUIDefinition = new XML(sUIDefinition);
			dispatchEvent(new PluginLoaderEvent(PluginLoaderEvent.XMLUI_COMPLETE));
			loadPluginModule();
		}

		private var loader:Loader;
		
		private function loadPluginModule():void
		{
			var urlRequest:URLRequest = new URLRequest(_moduleURL + _pluginUid + ".swf");
			loader = new Loader();
			var context:LoaderContext = new LoaderContext(false, new ApplicationDomain (ApplicationDomain.currentDomain), SecurityDomain.currentDomain);
			loader.addEventListener(Event.INIT, passPluginModule);
			loader.addEventListener(Event.COMPLETE, passPluginModule);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, passPluginModule);
			//loader.contentLoaderInfo.addEventListener(Event.INIT, passPluginModule);

			loader.load(urlRequest, context);
			
//xxx			moduleInfo = ModuleManager.getModule(_moduleURL + _pluginUid + ".swf");
//xxx			moduleInfo.addEventListener(ModuleEvent.PROGRESS, progressHandler);
//xxx			moduleInfo.addEventListener(ModuleEvent.READY, passPluginModule);
//xxx			moduleInfo.addEventListener(ModuleEvent.ERROR, catchModuleError);
			//31-03-2008 --> ApplicationDomain.currentDomain - we removed it, lets see why ?
			//93/04/2008 --> changed to new ApplicationDomain (ApplicationDomain.currentDomain) so that a second level loading application
			//will not cause confusion with ModuleManager application domain.
//xxx			moduleInfo.load (new ApplicationDomain (ApplicationDomain.currentDomain));
		}

		/**
		 * Handle progress of loading the module swf file
		 */
/*xxx		 
		private function progressHandler (e:ModuleEvent):void
		{
			//trace ("loading module: " + e.bytesLoaded / e.bytesTotal * 100 + "%");
			_bytesLoaded = e.bytesLoaded;
			_bytesTotal = e.bytesTotal;
		}
xxx*/
		/**
		 * Catches ModuleEvent.ERROR loading error events
		 */
/*xxx		 
		private function catchModuleError(evtModuleError:ModuleEvent):void
		{
			trace ("plugin_module_error: " + evtModuleError.errorText, "\n", evtModuleError.module.url);
			//throw evtModuleError;
		}
xxx*/

		/**
		 * Attaches  the loaded module's IModuleInfo to an the object which provides information about the module, as well as factory (IFlexModuleFactory) object,
		 * that enables Plugin objects instantiation.
		 * Invoked upon a ModuleEvent.READY is dispatched,
		 */

		//xxx private function passPluginModule(evtReady:ModuleEvent):void
		private function passPluginModule(evtReady:Event):void
		{
			dispatchEvent(new PluginLoaderEvent(PluginLoaderEvent.PLUGIN_INSTANCE_COMPLETE));
			itemLoaderComplete();
		}

		private function itemLoaderComplete():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}

		/**
		 * ItemLoader restrictions.xml definitions.
		 * @return 	restrictions xml.
		 *
		 */
		public function get restrictionsDefinition():XML
		{
			return _xmlRestrictions;
		}

		/**
		 * this ItemLoader ui.xml definitions
		 * @return 	ui xml.
		 *
		 */
		public function get UIDefinition():XML
		{
			return _xmlUIDefinition;
		}

		public function get loadingMode():String
		{
			return _sLoadingMode;
		}

		public function getLogicInstance():Plugin
		{
			var logicInstance:Plugin = null;
			
			logicInstance = loader.content['create'].apply();
			//xxx logicInstance = moduleInfo.factory.create() as Plugin;
			if (logicInstance)
				logicInstance.moduleUrl = _moduleURL;
			return logicInstance;
		}

        /**
         *return the total bytes.
         */
        public function get bytesTotal():uint
		{
			return _bytesTotal;
		}

        /**
         *return the bytes that have been loaded.
         */
        public function get bytesLoaded():uint
		{
			return _bytesLoaded;
		}

		/**
		 *return the url that is loaded.
		 */
		public function get url():String
		{
			return _moduleURL;
		}

		public function dispose ():void
		{
			//xxx if (moduleInfo)
			//xxx 	moduleInfo.release();
			//xxx moduleInfo = null;
			_xmlRestrictions = null;
			_xmlUIDefinition = null;
		}
	}
}