package com.kaltura.osmf.kalturaMix {

	import com.kaltura.KalturaClient;
	import com.kaltura.application.KalturaApplication;
	import com.kaltura.assets.AssetsFactory;
	import com.kaltura.assets.abstracts.AbstractAsset;
	import com.kaltura.base.context.PartnerInfo;
	import com.kaltura.base.types.MediaTypes;
	import com.kaltura.base.types.TimelineTypes;
	import com.kaltura.base.vo.KalturaPluginInfo;
	import com.kaltura.commands.mixing.MixingGetReadyMediaEntries;
	import com.kaltura.components.players.eplayer.Eplayer;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.managers.downloadManagers.types.StreamingModes;
	import com.kaltura.model.KalturaModelLocator;
	import com.kaltura.osmf.kaltura.KalturaBaseEntryResource;
	import com.kaltura.plugin.types.transitions.TransitionTypes;
	import com.kaltura.roughcut.Roughcut;
	import com.kaltura.types.KalturaEntryStatus;
	import com.kaltura.utils.url.URLProccessing;
	import com.kaltura.vo.KalturaMediaEntry;
	import com.kaltura.vo.KalturaMixEntry;
	import com.quasimondo.geom.ColorMatrix;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import mx.collections.ArrayCollection;
	import mx.core.MovieClipAsset;
	import mx.core.SpriteAsset;

	import org.osmf.traits.MediaTraitType;
	import org.puremvc.as3.interfaces.IFacade;


	public class KalturaMixSprite extends Sprite {
		// must have these classes compiled into code
		private var m:MovieClipAsset;
		private var f:SpriteAsset;
		private var c:ColorMatrix;

		/**
		 * mix plugin facade 
		 */		
		static public var facade:IFacade;
		
		private var kc:KalturaClient;

		/**
		 * mix player 
		 */		
		public var eplayer:Eplayer;

		/**
		 * entries ready
		 */		
		public var isReady:Boolean = false;

		private var _width:Number;
		private var _height:Number;

		private var kapp:KalturaApplication;
		private var mediaElement:KalturaMixElement;
		private var mixEntry:KalturaMixEntry;
		private var roughcut:Roughcut = null;

		static private var mixPluginsLoaded:Boolean = false;
		static private var pluginListLoader:URLLoader;
		
		/**
		 * @default false 
		 */		
		public var disableUrlHashing:Boolean = false;


		/**
		 * load different plugins
		 * @param data plugins data
		 */		
		public function loadPlugins(data:Object):void {
			var model:KalturaModelLocator = KalturaModelLocator.getInstance();
			var pluginsProvider:Array = data as Array;
			//var pluginsProvider:Array = data.result;
			/* pluginsProvider:   [transitionsArray, overlaysArray, textOverlaysArray, effectsArray] */
			var pinfo:KalturaPluginInfo;
			var baseUrl:String;
			var thumbUrl:String;
			var debugFromIDE:Boolean = kapp.applicationConfig.debugFromIDE;
			var pluginsUrl:String = URLProccessing.prepareURL(model.applicationConfig.pluginsFolder + "/", !debugFromIDE, false);
			for (var i:int = 0; i < pluginsProvider.length; ++i) {
				for (var j:int = 0; j < pluginsProvider[i].length; ++j) {
					pinfo = pluginsProvider[i].getItemAt(j) as KalturaPluginInfo;
					baseUrl = pluginsUrl + model.applicationConfig.transitionsFolder + "/" + pinfo.pluginId + "/";
					thumbUrl = pinfo.thumbnailUrl == '' ? baseUrl + "thumbnail.swf" : pinfo.thumbnailUrl;
					pinfo.thumbnailUrl = thumbUrl;
				}
			}
			kapp.transitions = pluginsProvider[0];
			kapp.overlays = pluginsProvider[1];
			kapp.textOverlays = pluginsProvider[2];
			kapp.effects = pluginsProvider[3];
			thumbUrl = model.applicationConfig.pluginsFolder + "/" + model.applicationConfig.transitionsFolder + "/thumbnail.swf";
			KalturaApplication.nullAsset.transitionThumbnail = URLProccessing.prepareURL(thumbUrl, true, false);
			model.logStatus = "plugins loaded and instantiated.";
			var nonePlugin:KalturaPluginInfo = model.transitions.getItemAt(0) as KalturaPluginInfo;
			AbstractAsset.noneTransitionThumbnail = nonePlugin.thumbnailUrl;
		}

		/**
		 * set plugin data before load
		 * @param data plugin data
		 */
		public function loadPlugingList(data:Object):void {
			var buildPlugin:Function = function(p:XML, media_type:uint):KalturaPluginInfo {
					var kpinf:KalturaPluginInfo = new KalturaPluginInfo(media_type, p.@plugin_id, p.@thumbnail, p.parent().@type, p.@label, p.@creator, p.description);
					return kpinf;
				}

			var pluginsXml:XML = data as XML;
			var transitionsArray:ArrayCollection = new ArrayCollection();
			var overlaysArray:ArrayCollection = new ArrayCollection();
			var textOverlaysArray:ArrayCollection = new ArrayCollection();
			var effectsArray:ArrayCollection = new ArrayCollection();
			var pinf:KalturaPluginInfo;
			var noneTransition:KalturaPluginInfo;
			var pluginXml:XML;
			for each (pluginXml in pluginsXml..transitions..plugin) {
				pinf = buildPlugin(pluginXml, MediaTypes.TRANSITION);
				if (pinf.category == "ignore")
					noneTransition = pinf;
				else
					transitionsArray.addItem(pinf);
			}
			transitionsArray.addItemAt(noneTransition, 0);
			for each (pluginXml in pluginsXml..overlays..plugin) {
				pinf = buildPlugin(pluginXml, MediaTypes.OVERLAY);
				overlaysArray.addItem(pinf);
			}
			for each (pluginXml in pluginsXml..textOverlays..plugin) {
				pinf = buildPlugin(pluginXml, MediaTypes.TEXT_OVERLAY);
				textOverlaysArray.addItem(pinf);
			}
			for each (pluginXml in pluginsXml..effects..plugin) {
				pinf = buildPlugin(pluginXml, MediaTypes.EFFECT);
				effectsArray.addItem(pinf);
			}

			loadPlugins([transitionsArray, overlaysArray, textOverlaysArray, effectsArray]);

		}

		/**
		 * get a list ready entries 
		 */
		public function getReadyEntries():void {
			var getMixReadyEntries:MixingGetReadyMediaEntries = new MixingGetReadyMediaEntries(mixEntry.id, mixEntry.version);

			getMixReadyEntries.addEventListener(KalturaEvent.COMPLETE, complete);
			getMixReadyEntries.addEventListener(KalturaEvent.FAILED, failed);
			kc.post(getMixReadyEntries);
		}


		private function failed(event:KalturaEvent):void {
			trace("getMixReadyEntries", event.toString());
		}


		private function complete(event:KalturaEvent):void {
			roughcut = new Roughcut(mixEntry);
			kapp.addRoughcut(roughcut);

			var readyEntriesResult:* = event.data;
			if (readyEntriesResult is Array) {
				var readyEntries:Array = readyEntriesResult as Array;
				var asset:AbstractAsset;
				var thumbUrl:String;
				var mediaUrl:String;
				for each (var entry:KalturaMediaEntry in readyEntries) {
					entry.mediaType = MediaTypes.translateServerType(entry.mediaType);
					asset = roughcut.associatedAssets.getValue(entry.id);
					if (asset)
						continue;
					kapp.addEntry(entry);
					if (entry.status != KalturaEntryStatus.BLOCKED && entry.status != KalturaEntryStatus.DELETED && entry.status != KalturaEntryStatus.ERROR_CONVERTING) {
						//thumbUrl = URLProccessing.hashURLforMultipalDomains (entry.thumbnailUrl, entry.id);
						mediaUrl = entry.mediaUrl;
						asset = AssetsFactory.create(entry.mediaType, 'null', entry.id, entry.name, thumbUrl, mediaUrl, entry.duration, entry.duration, 0, 0, TransitionTypes.NONE, 0, false, false, null, entry);
						asset.kalturaEntry = entry;
						asset.mediaURL = entry.dataUrl;
						asset.entryContributor = entry.creditUserName;
						asset.entrySourceCode = entry.sourceType;
						asset.entrySourceLink = entry.creditUrl;
						roughcut.associatedAssets.put(entry.id, asset);
						roughcut.originalAssets.addItem(asset);
						roughcut.mediaClips.addItem(asset);
					}
				}
			}
			isReady = true;
			if ((mediaElement.getTrait(MediaTraitType.PLAY) as KalturaMixPlayTrait).playState == "playing") {
				loadAssets();
			}
		/* var sdl:XML = new XML (mixEntry.dataContent);
		   roughcut.parseSDL (sdl, false);

		   var Timelines2Load:int = TimelineTypes.VIDEO | TimelineTypes.TRANSITIONS | TimelineTypes.AUDIO | TimelineTypes.OVERLAYS | TimelineTypes.EFFECTS;
		   roughcut.streamingMode = StreamingModes.PROGRESSIVE_STREAM_DUAL;
		   roughcut.loadAssetsMediaSources (Timelines2Load, roughcut.streamingMode);

		   eplayer.roughcut = roughcut;
		 (mediaElement.getTrait(MediaTraitType.TIME) as KalturaMixTimeTrait).setSuperDuration(roughcut.roughcutDuration); */
		}

		/**
		 * load media sources of assets 
		 */
		public function loadAssets():void {
			var sdl:XML = new XML(mixEntry.dataContent);
			roughcut.parseSDL(sdl, false);

			var Timelines2Load:int = TimelineTypes.VIDEO | TimelineTypes.TRANSITIONS | TimelineTypes.AUDIO | TimelineTypes.OVERLAYS | TimelineTypes.EFFECTS;
			roughcut.streamingMode = StreamingModes.PROGRESSIVE_STREAM_DUAL;
			roughcut.loadAssetsMediaSources(Timelines2Load, roughcut.streamingMode);

			eplayer.roughcut = roughcut;
			(mediaElement.getTrait(MediaTraitType.TIME) as KalturaMixTimeTrait).setSuperDuration(roughcut.roughcutDuration);
			(mediaElement.getTrait(MediaTraitType.DISPLAY_OBJECT) as KalturaMixViewTrait).isSpriteLoaded = true;
		}

		/**
		 * setup the sprite ui 
		 * @param _width	sprite width
		 * @param _height	sprite height
		 */
		public function setupSprite(_width:Number, _height:Number):void {
			this._width = _width;
			this._height = _height;
			graphics.beginFill(0xff);
			graphics.drawRect(0, 0, _width, _height);

			eplayer = new Eplayer();
			addChild(eplayer);
			eplayer.updateDisplayList(_width, _height);
		}


		/**
		 * Constructor. 
		 * @param _mediaElement
		 * @param _width
		 * @param _height
		 * @param isHashDisabled
		 */		
		public function KalturaMixSprite(_mediaElement:KalturaMixElement, _width:Number, _height:Number, isHashDisabled:Boolean) {
			disableUrlHashing = isHashDisabled;
			URLProccessing.disable_hashURLforMultipalDomains = disableUrlHashing;
			kapp = KalturaApplication.getInstance();
			mediaElement = _mediaElement;
			mixEntry = KalturaBaseEntryResource(mediaElement.resource).entry as KalturaMixEntry;
			setupSprite(_width, _height);

			var servicesProxy:Object = facade.retrieveProxy("servicesProxy");
			kc = servicesProxy.kalturaClient;

			var configProxy:Object = facade.retrieveProxy("configProxy");
			var flashvars:Object = configProxy.getData().flashvars;

			var app:KalturaApplication = KalturaApplication.getInstance();
			var partnerInfo:PartnerInfo = new PartnerInfo();
			partnerInfo.partner_id = kc.partnerId;
			partnerInfo.subp_id = "0";
			app.initKalturaApplication("", null);
			kapp.partnerInfo = partnerInfo;

			URLProccessing.serverURL = flashvars.httpProtocol + flashvars.host;
			URLProccessing.cdnURL = flashvars.httpProtocol + flashvars.cdnHost;

			if (!mixPluginsLoaded) {
				var baseUrl:String = kalturaMixPlugin.mixPluginsBaseUrl;
				kapp.applicationConfig.pluginsFolder = URLProccessing.completeUrl(baseUrl, URLProccessing.BINDING_CDN_SERVER_URL);

				var url:String = kapp.applicationConfig.pluginsFolder + "/" + (flashvars.mixPluginsListFile ? flashvars.mixPluginsListFile : "plugins.xml");
				var urlRequest:URLRequest = new URLRequest(url);
				pluginListLoader = new URLLoader();
				pluginListLoader.addEventListener(Event.COMPLETE, loadedPluginsList);
				pluginListLoader.load(urlRequest);
			}
			else {
				getReadyEntries();
			}
		}


		/**
		 * video width 
		 */		
		public function get videoWidth():Number {
			return this.width;
		}


		/**
		 * video height 
		 */
		public function get videoHeight():Number {
			return this.height;
		}


		private function loadedPluginsList(e:Event):void {
			pluginListLoader.removeEventListener(Event.COMPLETE, loadedPluginsList);
			mixPluginsLoaded = true;
			loadPlugingList(new XML(e.target.data));
			getReadyEntries();
		}
	}
}
