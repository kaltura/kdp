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
package com.kaltura.managers.downloadManagers.protocols
{
	import com.kaltura.application.KalturaApplication;
	import com.kaltura.assets.abstracts.AbstractAsset;
	import com.kaltura.base.types.MediaTypes;
	import com.kaltura.managers.downloadManagers.pluginManager.PluginLoadingModes;
	import com.kaltura.managers.downloadManagers.pluginManager.PluginMultiton;
	import com.kaltura.managers.downloadManagers.pluginManager.events.PluginFactoryEvent;
	import com.kaltura.managers.downloadManagers.protocols.interfaces.INetProtocol;
	import com.kaltura.model.KalturaModelLocator;
	import com.kaltura.net.loaders.interfaces.IMediaSourceLoader;
	import com.kaltura.plugin.logic.Plugin;
	import com.kaltura.utils.url.URLProccessing;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.Security;

	public class NetProtocolPlugin extends EventDispatcher implements INetProtocol
	{
		static public var model:KalturaModelLocator = KalturaModelLocator.getInstance();
		static public var loadingMode:String = PluginLoadingModes.PLAYER_MODE;
		private var pluginsFolder:String;

		private var moduleId:String;

		private var _asset:AbstractAsset;
		private var _callBack:Function;
		private var _roughcutEntryId:String = '-1';
		private var _roughcutEntryVersion:int = -1;

		public function get roughcutEntryId ():String
		{
			return _roughcutEntryId;
		}
		public function get roughcutEntryVersion ():int
		{
			return _roughcutEntryVersion;
		}
		public function get asset ():AbstractAsset
		{
			return _asset;
		}

		public function get callBack ():Function
		{
			return _callBack;
		}

		public function NetProtocolPlugin (roughcut_entry_Id:String, roughcut_entry_version:int):void
		{
			super ();
			_roughcutEntryId = roughcut_entry_Id;
			_roughcutEntryVersion = roughcut_entry_version;
			Security.allowDomain("*");
			pluginsFolder = model.applicationConfig.pluginsFolder;
		}

		public function load(source_asset:AbstractAsset):IMediaSourceLoader
		{
			_asset = source_asset;
			var moduleFolder:String;
			switch (_asset.mediaType)
			{
				case MediaTypes.OVERLAY:
					moduleFolder = "/" + model.applicationConfig.overlaysFolder + "/";
					break;

				case MediaTypes.TRANSITION:
					moduleFolder = "/" + model.applicationConfig.transitionsFolder + "/";
					break;

				case MediaTypes.EFFECT:
					moduleFolder = "/" + model.applicationConfig.effectsFolder + "/";
					break;
			}

			moduleId = _asset.mediaURL;
			var debugFromIDE:Boolean = KalturaApplication.getInstance().applicationConfig.debugFromIDE;
			var baseUrl:String = URLProccessing.prepareURL (pluginsFolder + moduleFolder, !debugFromIDE, false);
			PluginMultiton.getInstance().addEventListener(PluginFactoryEvent.LOGIC_INIT, pluginInstanceReady);
			PluginMultiton.getInstance().create (baseUrl, _asset.mediaURL, _asset.assetUID, NetProtocolPlugin.loadingMode);
			_asset.mediaURL = baseUrl;
			return null;
		}

		public function pluginInstanceReady (event:PluginFactoryEvent):void
		{
			if (event.uid == _asset.assetUID)
			{
				PluginMultiton.getInstance().removeEventListener(PluginFactoryEvent.LOGIC_INIT, pluginInstanceReady);
				var p:Plugin = event.plugin;
				if (!_asset.pluginAssetXml)
					_asset.pluginAssetXml = p.toXML();
				p.setProperties(_asset.pluginAssetXml);
				//xxx if (p.ui)
				//xxx	p.ui.setProperties(_asset.pluginAssetXml);
				p.moduleId = moduleId;
				_asset.transitionLabel = p.label;
				_asset.mediaSource = p;
				dispatchEvent (new Event (Event.COMPLETE));
			}
		}
	}
}