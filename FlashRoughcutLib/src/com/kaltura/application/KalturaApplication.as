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
package com.kaltura.application
{
	//xxx import com.adobe_kalturaprivate.adobe.cairngorm.control.CairngormEventDispatcher;
	//xxx import com.kaltura.application.events.GetBaseEntryMultiRequestEvent;
	//xxx import com.kaltura.application.events.InitKalturaApplicationEvent;
	//xxx import com.kaltura.application.events.LoadPluginsEvent;
	//xxx import com.kaltura.application.events.LoadRoughcutAssetsDataEvent;
	//xxx import com.kaltura.application.events.SetEntryThumbnailEvent;
	import com.kaltura.assets.AssetsFactory;
	import com.kaltura.assets.abstracts.AbstractAsset;
	import com.kaltura.base.context.KalturaApplicationConfig;
	import com.kaltura.base.context.PartnerInfo;
	import com.kaltura.base.types.MediaTypes;
	import com.kaltura.base.vo.KalturaPluginInfo;
	//xxx import com.kaltura.common.business.KalturaServices;
	//xxx import com.kaltura.control.KalturaController;
	import com.kaltura.dataStructures.HashMap;
	import com.kaltura.model.KalturaModelLocator;
	import com.kaltura.plugin.logic.effects.KEffect;
	import com.kaltura.plugin.logic.overlays.Overlay;
	import com.kaltura.plugin.logic.transitions.KTransition;
	import com.kaltura.plugin.types.transitions.TransitionTypes;
	import com.kaltura.roughcut.Roughcut;
	//xxx import com.kaltura.utils.colors.ColorsUtil;
	import com.kaltura.utils.url.URLProccessing;
	//import com.kaltura.versions.KMFVersion;
	import com.kaltura.vo.KalturaBaseEntry;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;

	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	import mx.utils.ObjectUtil;
	import mx.utils.URLUtil;

	/**
	 * Singleton manager that acts as a Facade to provide unified interface for managing a kaltura application, it's data and preforming operations on roughcuts.
	 * Flow:
	 * user application should call the loadServerConfig as the first call, and wait for it to init before calling any other facade operation.
	 * </p>
	 * KalturaEvents:
	 * <p>KalturaApplication manager will dispatch an Result or Fault event for evenry completion of request.
	 * In order to disable these events use: <code>KalturaApplication.getInstance().dispatchKalturaEvents = false;</code>
	 * Concurrency:
	 * <p>KalturaCVE supports concurrency of requests. In order to have multiple asynchronous requests:
	 * Whenever concurrency handling is needed, implement the <code>IResponder</code> interface and pass it as the responder parameter to that request.</p>
	 * @see mx.rpc.IResponder
	*/
	public class KalturaApplication extends EventDispatcher
	{
		//TODO: Find a way to remove these, we keep them here just for references in the link report.
		static private var overlayEmbed:Overlay;
		static private var effectEmbed:KEffect;
		static private var transitionEmbed:KTransition;
		static public var nullAsset:AbstractAsset;

		/**
		*make sure to populate the hashmap of the transitions before getting thumbnails by type.
		*/
		private var transitionsMapDirty:Boolean = true;
		/**
		*make sure to populate the hashmap of the overlays before getting thumbnails by type.
		*/
		private var overlaysMapDirty:Boolean = true;
		/**
		*make sure to populate the hashmap of the text overlays before getting thumbnails by type.
		*/
		private var textOverlaysMapDirty:Boolean = true;
		/**
		*make sure to populate the hashmap of the effects before getting thumbnails by type.
		*/
		private var effectsMapDirty:Boolean = true;

		/**
		 * map to keep transition pluginInfo for it's id.
		 */
		private var transitionsMap:HashMap;
		/**
		 *serve a repository of available transitions.
		 * @return 		the available transitions.
		 * @see com.kaltura.plugin.types.transitions.TransitionTypes
		 * @see com.kaltura.vo.KalturaPluginInfo
		 */
		//xxx [Bindable]
		public function get transitions ():ArrayCollection
		{
			return model.transitions;
		}
		public function set transitions (transitionsArray:ArrayCollection):void
		{
			model.transitions = transitionsArray;
		}

		/**
		 * map to keep overlay pluginInfo for it's id.
		 */
		private var overlaysMap:HashMap;
		/**
		 *serve a repository of available overlays.
		 * @return 		the available overlays.
		 * @see com.kaltura.vo.KalturaPluginInfo
		 */
		//xxx [Bindable]
		public function get overlays ():ArrayCollection
		{
			return model.overlays;
		}
		public function set overlays (overlaysArray:ArrayCollection):void
		{
			model.overlays = overlaysArray;
		}

		/**
		 * map to keep text overlay pluginInfo for it's id.
		 */
		private var textOverlaysMap:HashMap;
		/**
		 *serve a repository of available text overlays.
		 * @return 		the available text overlays.
		 * @see com.kaltura.vo.KalturaPluginInfo
		 */
		//xxx [Bindable]
		public function get textOverlays ():ArrayCollection
		{
			return model.textOverlays;
		}
		public function set textOverlays (overlaysArray:ArrayCollection):void
		{
			model.textOverlays = overlaysArray;
		}

		/**
		 * map to keep effects pluginInfo for it's id.
		 */
		private var effectsMap:HashMap;
		/**
		 *serve a repository of available effects.
		 * @return 		the available effects.
		 * @see com.kaltura.vo.KalturaPluginInfo
		 */
		//xxx [Bindable]
		public function get effects ():ArrayCollection
		{
			return model.effects;
		}
		public function set effects (effectsArray:ArrayCollection):void
		{
			model.effects = effectsArray;
		}

		//if set to true, commands will cause manager to dispatch result and fault events.
		public var dispatchKalturaEvents:Boolean = true;

		//xxx protected var controller:KalturaController;
		//xxx protected var services:KalturaServices;
		protected var model:KalturaModelLocator;

		//--------------------------------------------------------------------------------------
		//Facade interfaces:

		/**
		* the player's initialized width and height, this is used to init solid colors and images dimentions.
		*/
		public var initPlayerWidth:Number = 640;
		public var initPlayerHeight:Number = 480;

		/**
		 * loads the config.xml file and init the KalturaApplication model.
		 * <p>Support concurrency of requests - operation is asynchronous.</p>
		 * @param config_file_url			the url of the xml config file to load.
		 * @param partner_info				the partner info of this application, if null, JS function getPartnerInfo.
		 * @param load_config				Deprecated - should we load an external config file? (for debugging)
		 * @param host_code					sets the host server with which the cve application will communicate.
		 * @param debug_mode				sets debug mode for the application.
		 * @param responder					for concurrency pass a request reponder.
		 * @param cdn_host 					the kaltura cdn server domain name.
		 * @tiptext	initialize the Kaltura application.
		 */
		public function initKalturaApplication (config_file_url:String, partner_info:PartnerInfo, load_config:Boolean = false,
							host_code:String = "1", debug_mode:Boolean = false, responder:IResponder = null,
							locale_bundle_name:String = "kalturacvf", load_plugins:Boolean = false, cdn_host:String = "", client_tag:String = ''):void
		{
			//xxx controller = new KalturaController ();
			//xxx services = new KalturaServices ();
		  	model = KalturaModelLocator.getInstance();
			transitionsMap = new HashMap ();
			overlaysMap = new HashMap ();
			textOverlaysMap = new HashMap ();
			effectsMap = new HashMap ();
			nullAsset = AssetsFactory.create (MediaTypes.NULL, "null", '-1000', "NullAssets", "", "", 0, 0);
			//trace ("**************\nKalturaCVF build version is: " + KMFVersion.VERSION + "\n**************");
			//set the locale bundle name:
			//KalturaEntryStatus.localeBundleName = locale_bundle_name;
			MediaTypes.localeBundleName = locale_bundle_name;
			//var evt:InitKalturaApplicationEvent = new InitKalturaApplicationEvent (responder, config_file_url, partner_info,
			//														load_config, host_code, debug_mode, load_plugins, cdn_host, client_tag);
			//evt.dispatch();
		}

		/**
		 *loads the list of available plugins for this partner.
		 * <p>Support concurrency of requests - operation is asynchronous.</p>
		 * @param plugins_url			the base url to load all plugin instances from.
		 * @param plugins_provider		the file or service to get the list of plugins from.
		 * @param responder				a responder to notify result/fault.
		 */
		public function loadPluginsList (plugins_url:String, plugins_provider:String, responder:IResponder = null):void
		{
			model.applicationConfig.pluginsFolder = plugins_url;
			var debugMode:Boolean = model.applicationConfig.debugFromIDE;
			if (plugins_provider != '' && !URLUtil.isHttpURL(plugins_provider))
				plugins_provider = URLProccessing.prepareURL(plugins_provider, !debugMode, false);
			//xxx CairngormEventDispatcher.getInstance().dispatchEvent (new LoadPluginsEvent (responder, plugins_provider));
		}

		/**
		 * the framework build version.
		 * @return 	the compiled build version.
		 */
		public function get KalturaCVFVersion ():String
		{
			return "";//KMFVersion.VERSION;
		}

		/**
		 * sets debug mode for the application.
		 * <p>in debug mode, plugins will be loaded from a local folder.</p>
		 * @param debugMode		true if debug mode is desired.
		 */
		public function setApplicationDebugMode (debugMode:Boolean):void
		{
			model.applicationConfig.debugFromIDE = debugMode;
		}

		/**
		 *loads and instantiates partner info on the model of this application.
		 * @param partner_info		the partner info of this application, if null, function will read from JS function getPartnerInfo.
		 * @see com.kaltura.common.context.PartnerInfo
		 */
		public function readPartnerInfo (partner_info:PartnerInfo):void
		{
			if (partner_info)
			{
				model.partnerInfo = partner_info;
			} else {
				var _partnerInfo:Object = ExternalInterface.call("getPartnerInfo");
				model.logStatus = "got partner info:\n" + ObjectUtil.toString(_partnerInfo);
				if (_partnerInfo != null)
				{
					model.partnerInfo.ks 					= 		_partnerInfo.ks;
					model.partnerInfo.uid 					= 		_partnerInfo.uid;
					model.partnerInfo.partnerId 			= 		_partnerInfo.partnerId;
					model.partnerInfo.subpId 				= 		_partnerInfo.subpId;
				}
			}
			trace ("got partner info:\n" + ObjectUtil.toString(model.partnerInfo));
		}

		/**
		 *the partner information for this kaltura application.
		 * @return 	the partner info object.
		 * @see com.kaltura.common.context.PartnerInfo
		 */
		//xxx [Inspectable]
		//xxx [Bindable]
		public function get partnerInfo ():PartnerInfo
		{
			return model.partnerInfo;
		}
		public function set partnerInfo (partner_info:PartnerInfo):void
		{
			model.partnerInfo = partner_info;
			readPartnerInfo (partner_info);
		}

		/**
		 *the kaltura application configurations.
		 * @return 	the configuration of this kaltura application (as shown on config.xml).
		 * @see com.kaltura.common.context.KalturaApplicationConfig
		 */
		//xxx [Inspectable]
		//xxx [Bindable]
		public function get applicationConfig ():KalturaApplicationConfig
		{
			return model.applicationConfig;
		}
		public function set applicationConfig (application_config:KalturaApplicationConfig):void
		{
			model.applicationConfig = application_config;
		}

		/**
		 *sets a new thumbnail to a given entry.
		 * @param entry_id								the id of the entry to set it's thumbnail.
		 * @param entry_version							the version of the roughcut to set it's thumbnail.
		 * @param thumbnail								the thumbnail to save, encoded as Jpeg on ByteArray.
		 * @see mx.graphics.codec.JPEGEncoder
		 */
		public function setEntryThumbnail (entry_id:String, entry_version:int, thumbnail:ByteArray, responder:IResponder = null):void
		{
			//xxx CairngormEventDispatcher.getInstance().dispatchEvent (new SetEntryThumbnailEvent (responder, entry_id, thumbnail, entry_version));
		}

		/**
		 *instantiate and loads the binary data of the roughcut's assets (video, audio, voice, plugins...).
		 * @param entry_id				the id of the roughcut to load it's mediaSources.
		 * @param entry_version			the version of the roughcut to load it's mediaSources.
		 * @param streamingMode			determine the serving method used to get the media files.
         * @see com.kaltura.managers.downloadManagers.types.StreamingModes
		 * @see com.kaltura.assets.abstracts.AbstractAsset#mediaSource
		 */
		public function loadRoughcutAssetsMediaSource (entry_id:String, entry_version:int, streaming_mode:int = 0):void
		{
			//xxx CairngormEventDispatcher.getInstance().dispatchEvent (new LoadRoughcutAssetsDataEvent (entry_id, entry_version, streaming_mode));
		}

		/**
		 *loads an entry by requesting a multirequest that is designed to get all related information for an entry and it's kshow.
		 * @param entry_id				the id of the entry to load.
		 * @param entry_version			the version of the entry to load.
		 * @param validate_sdl			specify if should validate sdl versus getallentries result.
		 * @param checkPending			if true will check entries for validation (status).
		 * @param responder				for concurrency pass a request reponder.
		 * @see com.kaltura.base.types.ListTypes
		 */
		public function loadEntryMultirequest (entry_id:String, entry_version:int = -1, validate_sdl:Boolean = true, checkPending:Boolean = true, responder:IResponder = null):void
		{
			//xxx CairngormEventDispatcher.getInstance().dispatchEvent (new GetBaseEntryMultiRequestEvent (responder, entry_id, entry_version, validate_sdl, checkPending));
		}

		/**
		 * decide if flex should show bussy cursor on asynchronous requests.
		 * @param val	if set to true, flex will set the cursor to bussy mode uppon calling to asynchronous requests.
		 */
		public function showBussyCursor (val:Boolean):void
		{
			//xxx KalturaServices.showBussyCursor = val;
		}
		//--------------------------------------------------------------------------------------
		//internal framework managment.


		/**
		 * adds a new KalturaBaseEntry to the model.
		 * @param kentry		the KalturaBaseEntry to add.
		 */
		public function addEntry (kentry:KalturaBaseEntry):void
		{
			if (model && model.entriesMap)
				model.entriesMap.put (kentry.id.toLowerCase() + "." + kentry.version.toString(), kentry);
		}

		/**
		 * get a KalturaBaseEntry.
		 * @param entryId	the entry id of the KalturaBaseEntry.
		 * @return 			the KalturaBaseEntry of the given entry_id.
		 */
		public function getEntry (entryId:String, entryVersion:String):KalturaBaseEntry
		{
			if (model && model.entriesMap)
				return model.entriesMap.getValue(entryId.toLowerCase() + "." + entryVersion.toLowerCase()) as KalturaBaseEntry;
			return null;
		}

		/**
		 *disposes (delete from memory) the entry with the given id.
		 * @param entryId			the id of the entry to dispose.
		 * @param entryVersion 		the version of the entry to dispose.
		 * @return true if the given id represents an entry in memory and it was disposed, false if the id does not exist.
		 */
		public function disposeEntry (entryId:String, entryVersion:int = -1):Boolean
		{
			if (model && model.entriesMap && model.entriesMap.containsKey(entryId.toLowerCase() + "." + entryVersion))
			{
				model.entriesMap.remove(entryId.toLowerCase() + "." + entryVersion);
				return true;
			}
			return false;
		}

		/**
		 * adds a new Roughtcut to the model.
		 * @param roughcut		the Roughcut to add.
		 */
		public function addRoughcut (roughcut:Roughcut):void
		{
			if (model && model.roughcutsMap)
				model.roughcutsMap.put (roughcut.id.toLowerCase() + "." + roughcut.version.toString(), roughcut);
		}
		/**
		 * get a Roughcut.
		 * @param roughcutId		the entry_id of the Roughcut.
		 * @return 					the Roughcut with the given entry_id.
		 */
		public function getRoughcut (roughcutId:String, roughcutVersion:int):Roughcut
		{
			if (model && model.roughcutsMap)
				return model.roughcutsMap.getValue(roughcutId.toLowerCase() + "." + roughcutVersion) as Roughcut;
			return null;
		}

		/**
		 *disposes (delete from memory) the rougcut with the given id.
		 * @param roughcutId			the id of the roughcut to dispose.
		 * @param roughcutVersion		the version of the roughcut to dispose.
		 * @return true if the given id represents a roughcut in memory and it was disposed, false if the id does not exist.
		 */
		public function disposeRoughcut (roughcutId:String, roughcutVersion:int = -1):Boolean
		{
			var roughcut:Roughcut = getRoughcut (roughcutId, roughcutVersion);
			if (roughcut)
			{
				roughcut.dispose();
				model.roughcutsMap.remove(roughcutId.toLowerCase() + "." + roughcutVersion);
				disposeEntry (roughcutId, roughcutVersion);
				return true;
			}
			return false;
		}


		///
		///		P L U G I N S
		///

		private function getPluginTypeInfo (media_type:uint):Array
		{
			var collection:ArrayCollection;
			var map:HashMap;
			var dirty:Boolean;
			collection =	media_type & MediaTypes.OVERLAY ? overlays :
							media_type & MediaTypes.TEXT_OVERLAY ? textOverlays :
							media_type & MediaTypes.EFFECT ? effects :
							media_type & MediaTypes.TRANSITION ? transitions : null;
			map 	=	 	media_type & MediaTypes.OVERLAY ? overlaysMap :
							media_type & MediaTypes.TEXT_OVERLAY ? textOverlaysMap :
							media_type & MediaTypes.EFFECT ? effectsMap :
							media_type & MediaTypes.TRANSITION ? transitionsMap : null;
			dirty 	=		media_type & MediaTypes.OVERLAY ? overlaysMapDirty :
							media_type & MediaTypes.TEXT_OVERLAY ? textOverlaysMapDirty :
							media_type & MediaTypes.EFFECT ? effectsMapDirty :
							media_type & MediaTypes.TRANSITION ? transitionsMapDirty : null;
			return [collection, map, dirty];
		}

		/**
		 *get the label of a plugin by its plugin id.
		 * @param plugin_id			the type of the plugin.
		 * @param media_type		the media type of the plugin.
		 * @return 					the url for the plugin thumbnail.
		 */
		public function getPluginLabel (plugin_id:String, media_type:uint):String
		{
			var ptype:Array = getPluginTypeInfo (media_type);
			if (!ptype[0])
				throw new Error ("Not a valid media type.");
			var collection:ArrayCollection = ptype[0];
			var map:HashMap = ptype[1];
			var dirty:Boolean = ptype[2];
			if (dirty)
				buildPluginsMap (collection, map, media_type);
			var pinfo:KalturaPluginInfo = map.getValue(plugin_id) as KalturaPluginInfo;
			if (pinfo) {
				return pinfo.label;
			} else {
				return null;
			}
		}

		/**
		 *get the thumbnail of a plugin by its plugin id.
		 * @param plugin_id			the type of the plugin.
		 * @param media_type		the media type of the plugin.
		 * @return 					the url for the plugin thumbnail.
		 */
		public function getPluginThumbnail (plugin_id:String, media_type:uint):String
		{
			var ptype:Array = getPluginTypeInfo (media_type);
			if (!ptype[0])
				throw new Error ("Not a valid media type.");
			var collection:ArrayCollection = ptype[0];
			var map:HashMap = ptype[1];
			var dirty:Boolean = ptype[2];
			if (dirty)
				buildPluginsMap (collection, map, media_type);
			var pinfo:KalturaPluginInfo = map.getValue(plugin_id) as KalturaPluginInfo;
			if (pinfo)
				return pinfo.thumbnailUrl;
			else
				return null;
		}

		/**
		 *get the label of a transition by its plugin id.
		 * @param transition_id		the type of the transition.
		 * @return 					the url for the transition thumbnail.
		 */
		public function getTransitionLabel (transition_id:String):String
		{
			//	[Deprecated(replacement="getTransitionLabel was deprecated, please use getPluginLabel.", since="1.0.9.x")]
			var label:String = getPluginLabel (transition_id, MediaTypes.TRANSITION);
			if (label === null)
			{
				var pinfo:KalturaPluginInfo = transitionsMap.getValue(TransitionTypes.NONE) as KalturaPluginInfo;
				if (pinfo)
					return pinfo.label;
			}
			return label;
		}

		/**
		 *get the thumbnail of a transition by its plugin id.
		 * @param transition_id		the type of the transition.
		 * @return 					the url for the transition thumbnail.
		 */
		public function getTransitionThumbnail (transition_id:String):String
		{
			//	[Deprecated(replacement="getTransitionLabel was deprecated, please use getPluginThumbnail.", since="1.0.9.x")]
			var thumbUrl:String = getPluginThumbnail (transition_id, MediaTypes.TRANSITION);
			if (thumbUrl === null)
			{
				return TransitionTypes.NONE;
			}
			return thumbUrl;
		}

		/**
		 * builds the plugins hashmap.
		 * @param plugins			the plugins collection.
		 * @param map				the map of this plugins type.
		 * @param media_type		the media type of the plugin.
		 */
		private function buildPluginsMap (plugins:ArrayCollection, map:HashMap, media_type:uint):void
		{
			var N:uint = plugins.length;
			var i:int = 0;
			for (; i < N; ++i)
			{
				var pinfo:KalturaPluginInfo = plugins.getItemAt(i) as KalturaPluginInfo;
				map.put (pinfo.pluginId, pinfo);
			}
			switch (media_type)
			{
				case MediaTypes.TRANSITION:
					transitionsMapDirty = false;
					break;
				case MediaTypes.OVERLAY:
					overlaysMapDirty = false;
					break;
				case MediaTypes.TEXT_OVERLAY:
					textOverlaysMapDirty = false;
					break;
				case MediaTypes.EFFECT:
					effectsMapDirty = false;
					break;
			}
		}

		//--------------------------------------------------------------------------------------
		//manager dispatcher:
		override public function dispatchEvent(event:Event):Boolean
		{
			if (dispatchKalturaEvents)
			{
				return super.dispatchEvent(event);
			}
			return false;
		}


		//--------------------------------------------------------------------------------------
		//singleton instance
		static private var kAppInstance:KalturaApplication;
		static public function getInstance ():KalturaApplication
		{
			if (kAppInstance == null)
			{
				kAppInstance = new KalturaApplication ();
				//xxx ColorsUtil.init();
			}
			return kAppInstance;
		}

		public function KalturaApplication ():void
		{
			if (kAppInstance != null)
				throw (new Error ("Singleton: use getInstance instead."));
			kAppInstance = this;
		}
		//--------------------------------------------------------------------------------------
	}
}