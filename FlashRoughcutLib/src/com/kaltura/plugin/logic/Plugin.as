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
package com.kaltura.plugin.logic
{
	import com.kaltura.net.interfaces.IMediaSource;
	import com.kaltura.plugin.IPlugin;
	import com.kaltura.plugin.events.PluginEvent;
	import com.kaltura.plugin.logic.properties.Properties;
	import com.kaltura.plugin.logic.properties.restrictions.Restrictions;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.system.Security;

	[Event(name="ready", type="plugin.events.PluginEvent")]
	public class Plugin extends EventDispatcher implements IPlugin, IMediaSource
	{
		public static const REFLECTION:String = "PLUGIN";

		protected var _sName:String;
		protected var _Properties:Properties
		//xxx protected var _ui:PluginUI;
		protected var _sBindName:String;

		/**
		* the url of the source module swf.
		*/
		public var moduleUrl:String;

		/**
		* the id of this plugin's module as it was defined by the server.
		*/
		public var moduleId:String;

		public function Plugin (url:String = ""):void
		{
			_Properties = new Properties();
			Security.allowDomain("*");
			moduleUrl = url;
		}

		public function get reflection ():String
		{
			return Plugin.REFLECTION;
		}

		/**
		* Video display area width.
		*/
		protected var _nVideoWidth:Number;

		/**
		* Video display area height.
		*/
		protected var _nVideoHeight:Number;

		/**
		* Plugin version
		*/
		private var _sVersion:String;

		/**
		 * Sets this plugin definition from an XML document.
		 * This method must be called only once per plugin before applying the plugin to its target.
		 * @param xmlDef
		 *
		 */
		public function setDefinition(restrictions:Restrictions):void
		{
			_sName = restrictions.name;
			_sVersion = restrictions.version;
			_Properties.setDefinition(restrictions);
			dispatchEvent(new PluginEvent(PluginEvent.DEFINITIONS_LOADED));
		}

		/**
		 * sets this plugin's properties according to the passed XML
		 * @param xmlProps
		 *
		 */
		public function setProperties(xmlArguments:XML):void
		{
			if (!_Properties)
			{
				trace ("ERROR IN PLUGIN ( " + _sName + " ), Properties = null, possibly plugin is used after dispose.");
				return;
			}
			var sPassedName:String = xmlArguments.name.text();
			if (_sName == sPassedName)
			{
				_Properties.setProperties(xmlArguments.arguments[0]);
			} else {
				throw new Error("The arguments contains the name '" + sPassedName + "' while the Plugin name is '" + _sName + "'");
			}
		}

		/**
		 *a function to handle changes in the plugin ui elements and reflect the changes on the logic.
		 * @param event		ui change event holds all relevant change attributes.
		 */
/* 		public function handleChangePluginUiArguments (event:PluginUIEvent):void
		{
			setProperties(event.changedArgument);
		}
 */
		/**
		 * Returns this Plugin's parameters in an xml format
		 * @return
		 */
		public function toXML():XML
		{
 			var xmlPlugin:XML = <plugin>
 									<version>{_sVersion}</version>
 									<name>{_sName}</name>
 								</plugin>;
			xmlPlugin.appendChild( _Properties.toXML() );
			return xmlPlugin;
		}

		/**
		* the label of this plugin (this is the name of the plugin as stated by it's createor).
		*/
		//xxx[Bindable]
		public function get label():String
		{
			return _sName;
		}

		public function set label(sName:String):void
		{
			_sName = sName;
		}

		/**
		 * Resets this Plugin to its default value by setting the Properties object to its default values
		 */
		public function resetToDefault():void
		{
			_Properties.resetToDefault();
		}

		public function get properties():Properties
		{
			return _Properties;
		}

		/**
		 * Sets the target layer/s of this plugin back to default and disposes the reference to the layer
		 * after the transition ended.
		 * detach() is an abstract function to be overriden by a concrete implementation.
		 */
		public function detach(nScreenWidth:Number, nScreenHeight:Number, nX:Number, nY:Number):void
		{
			throw new Error("Plugin class doesn't implement a concrete detach method");
		}

		/**
		 * This Plugin PluginUI instance
		 * @return
		 *
		 */
/* 		public function get ui():PluginUI
		{
			return _ui;
		}
 */
/* 		public function set ui(pluginUI:PluginUI):void
		{
			_ui = pluginUI;
		}
 */
		/**
		 * Returns this Plugin version (e.g. "1.0.5")
		 * @return
		 *
		 */
		public function get version():String
		{
			return _sVersion
		}

		/**
		 * Set this plugin display area width and height dimensions
		 * Invoked after setTarget() has been executed.
		 *
		 */
		protected function setDisplaySize():void
		{

		}

		/**
		 * An abstract method to be overwritten by a concrete initialization method.
		 * @return
		 *
		 */
		public function pluginAdded():void
		{
			//trace (REFLECTION, "Plugin.init() is an abstract method");
		}

		/**
		 *creation complete will be called after plugin module finish loading and instantiation.
		 *at that stage, plugin instance will have it's base url and is ready to be used.
		 */
		public function creationComplete ():void
		{

		}

		/**
		 *
		 * Set this plugin display area width and height dimensions
		 * Invoked befire any call to apply(), init() and setTargets
		 *
		 * @param nWidth Video panel width
		 * @param nHeight Video panel height
		 *
		 */
		public function setDimensions(nVideoWidth:Number, nVideoHeight:Number):void
		{
			_nVideoWidth = nVideoWidth;
			_nVideoHeight = nVideoHeight;
		}

		/**
		 * Gets this plugin LayersContainer object which holds the currently playing video and the next video to be played
		 * @param layers A LayerContainer class instance
		 *
		 */
		public function setTargets(layers:DisplayObject):void
		{
			pluginAdded();
			//throw new Error("Plugin.setTargets is an abstract method to be overwritten by a concrete method");
		}

		/**
		 * Disposes the object for th GC to collect.
		 *
		 */
		public function dispose ():void
		{
			_Properties = null;
			//_ui = null;
		}

/**
*IMediaSource:
*/
		/**
		 * Resume the plugin from it's current state.
		 * Implemented by the concrete plugin itself, and is not mandatory.
		 */
		public function playMedia ():void
		{
		}

		/**
		 * Pasuses the plugin at it's current state.
		 * Implemented by the concrete plugin itself, and is not mandatory.
		 */
		public function pauseMedia ():void
		{

		}

		/**
		 *seek the plugin with the offset and original duration of plugin
		 * @param offset		offset
		 * @param original		duration of the plugin
		 * @param direction
		 *
		 */
		public function seekMedia (offset:Number, original:Number = -1, direction:Boolean = false):void
		{

		}

		public function get mediaBitmapData ():BitmapData
		{
			return null;
		}
	}
}