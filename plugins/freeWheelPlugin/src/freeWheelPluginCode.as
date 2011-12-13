package
{
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.SequenceContextType;
	import com.kaltura.kdpfl.plugin.IMidrollSequencePlugin;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.ISequencePlugin;
	import com.kaltura.kdpfl.plugin.KPluginEvent;
	import com.kaltura.kdpfl.view.CuePointsMediator;
	import com.kaltura.types.KalturaAdProtocolType;
	import com.kaltura.types.KalturaAdType;
	import com.kaltura.vo.KalturaAdCuePoint;
	import com.kaltura.vo.KalturaCuePoint;
	
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.system.Security;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import org.osmf.media.MediaElement;
	import org.puremvc.as3.interfaces.IFacade;
	
	import tv.freewheel.ad.behavior.IAdManager;
	import tv.freewheel.ad.behavior.IConstants;
	import tv.freewheel.ad.behavior.IEvent;
	import tv.freewheel.ad.behavior.ISlot;
	import tv.freewheel.ad.loader.AdManagerLoader;
	import tv.freewheel.logging.Logger;
	import tv.freewheel.wrapper.kaltura.FreeWheelMediator;
	import tv.freewheel.wrapper.kaltura.FreeWheelParameters;
	import tv.freewheel.wrapper.osmf.slot.FWSlotElement;
	
	public class freeWheelPluginCode extends Sprite implements IPlugin, ISequencePlugin, IMidrollSequencePlugin
	{
		public static const NAME:String = "FreeWheelPluginCode";
		public static const FROM_FREEWHEEL:String = "fromFreewheel";
		private const CP_VIEWED:String = "viewed";
		private const CP_NOT_VIEWED:String = "notViewed";
		
		private var amLoader:AdManagerLoader;
		private var am:IAdManager;
		public var constants:IConstants;
		private var logger:Logger;
		private var prerollSlots:Array;
		private var postrollSlots:Array;
		private var cuePointSlots:Object; // timeposition as key, islot as value
		private var midrollArr:Array;
		
		// Plugin attributes
		public var postSequence:Number;
		public var preSequence:Number;
		public var asyncInit:Boolean = true;  // required by KDP for async init plugin
		
		// states of this plugin
		private var mediator:FreeWheelMediator;
		private var sequenceContextType:String;
		private var facade:IFacade;
		
		private var parameters:FreeWheelParameters;
		
		// counters
		private var numPreroll:int;
		private var numPostroll:int;
		private var extensionLoadingCount:int;
		
		// flags
		private var adManagerLoaded:Boolean = false;
		private var entryReady:Boolean = false;
		private var requestCompleted:Boolean = false;
		private var startPending:Boolean = false;
		private var extensionLoadTimeout:Boolean = false;
		private var enable:Boolean = true;
		
		// timer
		private var extTimer:Timer;
		
		// saved values in case AdManager is not ready when these values are passed in
		private var adVolume:Number = 100;
		
		private var _overlays:Object;
		private var _currentBaseUnit:String;
		private var _autoContinue:Boolean = true;
		private var _useKalturaTemporalSlots:Boolean = false;
		private var _cuePointTags:String = "";
		private var _allowScanOnPage:Boolean = true;
		private var _playAdsByOrder:Boolean;
		//array of ads by their order, to be used when playAdsByOrder=true
		private var _orderedAds:Array;
		//key-cuePointId, value-viewed/notViewed. will be used when playAdsByOrder=true
		private var _cpStatus:Object;
		//index of the next CP to view, to be used when payAdsByOrder=true
		private var _nextCPIndex:int = 0;
		
		private var _logLevel:String = AdManagerLoader.LEVEL_DEBUG;
		
		public function freeWheelPluginCode()
		{
			flash.system.Security.allowDomain('*');
			this.logger = Logger.getSimpleLogger("KDPPlugin ");
			this.parameters = new FreeWheelParameters();
		}
		
		[Bindable]
		/**
		 * log level for loading the ad manager 
		 * @return 
		 * 
		 */		
		public function get logLevel():String
		{
			return _logLevel;
		}

		public function set logLevel(value:String):void
		{
			_logLevel = value;
		}

		[Bindable]
		public function get cuePointTags():String
		{
			return _cuePointTags;
		}
		
		public function set cuePointTags(value:String):void
		{
			_cuePointTags = value;
		}
		
		[Bindable]
		/**
		 * Wether to use kalturaCuePoints 
		 * @return 
		 * 
		 */		
		public function get useKalturaTemporalSlots():Boolean
		{
			return _useKalturaTemporalSlots;
		}
		
		public function set useKalturaTemporalSlots(value:Boolean):void
		{
			_useKalturaTemporalSlots = value;
			if (!value)
				this.mediator.waitingForCuePoints = false;
		}
		
		[Bindable]
		/**
		 * if true, ads will be playing by the order they returned from the server.
		 * regardless to timePosition of cue point
		 * */
		public function get playAdsByOrder():Boolean
		{
			return _playAdsByOrder;
		}
		
		public function set playAdsByOrder(value:Boolean):void
		{
			_playAdsByOrder = value;
		}
		
		[Bindable]
		/**
		 * will allow the adManager to scan slots on page
		 * */
		public function get allowScanOnPage():Boolean
		{
			return _allowScanOnPage;
		}
		
		public function set allowScanOnPage(value:Boolean):void
		{
			_allowScanOnPage = value;
		}
		
		/**
		 * determines whether to move to next ad once current ad ended
		 * */
		public function get autoContinue():Boolean
		{
			return _autoContinue;
		}
		
		public function set autoContinue(value:Boolean):void
		{
			_autoContinue = value;
		}
		
		[Bindable]
		/**
		 * baseUnit of current playing ad
		 * */
		public function get currentBaseUnit():String
		{
			return _currentBaseUnit;
		}
		
		public function set currentBaseUnit(value:String):void
		{
			_currentBaseUnit = value;
		}
		
		private function get mediaProxy():MediaProxy{
			return facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
		}
		
		private function get sequenceProxy():SequenceProxy{
			return facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
		}
		
		private function get configProxy():ConfigProxy{
			return facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
		}
		
		//////// Implement IPlugin methods, start
		public function initializePlugin(facade:IFacade):void
		{
			this.logger.debug('initializePlugin()');
			this.facade = facade;
			
			// TODO: flashvars will be deprecated in the future, remove the following configProxy.vo.flashvars
			this.parameters.parseParameters(configProxy.vo.flashvars);
			this.logger.debug(this.parameters.toString());
			
			if (this.parameters.adManagerUrl){
				// Create and register the mediator with the PureMVC facade
				this.mediator = new FreeWheelMediator(this);
				facade.registerMediator(this.mediator);
				
				this.amLoader = new AdManagerLoader();
				this.amLoader.loadAdManager(this, amLoaded, logLevel, this.parameters.adManagerUrl, 0);
			}
			else{
				this.logger.error("adManagerUrl is null.");
				this.signalPluginLoaded(false);
			}
		}
		
		private function signalPluginLoaded(success:Boolean):void{
			this.logger.debug('signalPluginLoaded(' + success + ')');
			if (success){
				this.dispatchEvent(new KPluginEvent(KPluginEvent.KPLUGIN_INIT_COMPLETE));
			}
			else{
				this.dispatchEvent(new KPluginEvent(KPluginEvent.KPLUGIN_INIT_FAILED));
				// set flags so that the plugin can work transparently without hanging the main video
				// this should have been handled by kdp! :(
				// OK, so now they are said to handle it, but I leave this switch here just in case.
				this.enable = false;
			}
		}
		
		private function amLoaded(success:Boolean, msg:String):void{
			this.logger.debug('amLoaded(' + success + ', ' + msg + ')');
			if (success){
				this.adManagerLoaded = true;
				this.initAdManager();
			}
			this.signalPluginLoaded(success);
			
		}
		
		public function initAdManager():void{
			this.logger.debug('initAdManager()');
			if (this.adManagerLoaded && this.entryReady){
				if (!this.am){
					this.am = this.amLoader.newAdManager();
					this.constants  = this.am.getConstants();
				}
				// re-parse parameters since we now have entryMetadata
				this.reset();
				this.parameters.parseParameters(this.configProxy.vo.flashvars, this.mediator.entryMetadata, this.mediator.entryCuePoints);
				this.logger.debug(this.parameters.toString());
				if (!this.parameters.validate()){
					this.logger.error("\n##########\nKDPPlugin is disabled because: " + this.parameters.errors.join(' ') + '\n##########');
					this.enable = false;
					return;
				}
				this.mediator.reset();
				this.configAm();
			}
		}
		
		public function notifyEntryReady():void{
			this.logger.debug('notifyEntryReady()');
			this.entryReady = true;
			this.requestCompleted = false;
			this.initAdManager();
		}
		
		public function resize():void{
			this.logger.debug('resize()');
			if (this.am){
				var rect:Rectangle = this.mediator.playerDimension;
				this.am.setVideoDisplaySize(rect.x, rect.y, rect.width, rect.height, rect.x, rect.y, rect.width, rect.height);
			}
		}
		
		private function reset():void{
			this.logger.debug('reset()');
			if (this.am){
				this.resize();
				this.am.setVideoPlayStatus(this.constants.VIDEO_STATUS_STOPPED);
				this.am.refresh();
			}
			this.cuePointSlots = new Object();
			this.prerollSlots = [];
			this.postrollSlots = [];
			this.midrollArr = new Array();
			this.numPostroll = 0;
			this.numPreroll = 0;
			this.enable = true;
		}
		
		private function configAm():void{
			this.logger.debug("configAm()");
			
			this.am.setServer(this.parameters.serverUrl);
			this.am.setNetwork(this.parameters.networkId);
			this.am.setProfile(this.parameters.playerProfile);
			this.am.setAdVolume(this.adVolume);
			this.am.registerVideoDisplay(this.mediator.slotBase);
			this.am.setVideoAsset(this.parameters.videoAssetId,
				this.mediaProxy.vo.entry.duration,
				this.mediaProxy.vo.entry.downloadUrl,
				this.mediator.isAutoPlay,
				Math.round(Math.random() * 100000),
				this.parameters.videoAssetNetworkId,
				this.parameters.videoAssetIdType,
				this.parameters.videoAssetFallbackId,
				this.constants.VIDEO_ASSET_DURATION_TYPE_EXACT); // no live mode support in the first release
			this.am.setSiteSection(this.parameters.siteSectionId,
				Math.round(Math.random() * 100000),
				this.parameters.siteSectionNetworkId,
				this.parameters.siteSectionIdType,
				this.parameters.siteSectionFallbackId);
			this.am.setRendererConfiguration(this.parameters.rendererConfiguration);
			for each (var kv:Object in this.parameters.keyValues){
				for (var k:String in kv){
					this.am.setKeyValue(k, kv[k]);
				}
			}
			for (var paramName:String in this.parameters.overrideParameters){
				this.am.setParameterObject(paramName, this.parameters.overrideParameters[paramName], this.constants.PARAMETER_OVERRIDE);
			}
			
			var capStatus:Object = new Object();
			capStatus[1] = this.constants.CAPABILITY_STATUS_ON;
			capStatus["1"] = this.constants.CAPABILITY_STATUS_ON;
			capStatus[0] = this.constants.CAPABILITY_STATUS_OFF;
			capStatus["0"] = this.constants.CAPABILITY_STATUS_OFF;
			for (var capName:String in this.parameters.capabilities){
				this.am.setCapability(capName, capStatus[this.parameters.capabilities[capName]]);
			}
			this.am.setVisitor(this.parameters.customVisitor);
			this.am.addEventListener(this.constants.EVENT_EXTENSION_LOADED, onExtensionLoaded);
			this.extensionLoadingCount = 0;
			for (var extName:String in this.parameters.extensions){
				this.am.loadExtension(extName, this.parameters.extensions[extName]);
				this.extensionLoadingCount++;
			}
			if (allowScanOnPage)
				this.am.scanSlotsOnPage();
			this.am.registerPlayheadTimeCallback(this.mediator.getPlayheadTime);
			
			var cuePointSeq:int = 1;
			_cpStatus = new Object();
			
			if (useKalturaTemporalSlots) {
				for (var cuePointId:String in this.parameters.cuePoints){
					var cuePoint:KalturaAdCuePoint = this.parameters.cuePoints[cuePointId] as KalturaAdCuePoint;
					var adUnit:String = findAdUnit(cuePoint);
					
					this.am.addTemporalSlot(cuePoint.id,
						adUnit, (cuePoint.startTime / 1000), null, 0, 0, null, null, null, 0,
						(adUnit == this.constants.ADUNIT_MIDROLL) ? cuePointSeq++ : 0);
					
					_cpStatus[cuePoint.id] = CP_NOT_VIEWED;
					
				}
			}
			
			if (this.extensionLoadingCount == 0){
				this.submitRequest();
			}
			else{
				this.extTimer = new Timer(5000);
				this.extTimer.addEventListener(TimerEvent.TIMER, onExtensionTimeout);
				this.extTimer.start();
			}
		}
		
		private function findAdUnit(cp:KalturaCuePoint):String 
		{
			if (cp.startTime==0)
				return this.constants.ADUNIT_PREROLL;
			if (cp.startTime == mediaProxy.vo.entry.msDuration)
				return this.constants.ADUNIT_POSTROLL;
			if (cp.adType == KalturaAdType.OVERLAY)
				return this.constants.ADUNIT_OVERLAY;
			else
				return this.constants.ADUNIT_MIDROLL;
		}
		
		private function onExtensionLoaded(evt:IEvent):void{
			this.logger.debug('onExtensionLoaded()');
			this.extensionLoadingCount--;
			if (this.extensionLoadingCount == 0){
				this.disposeExtensionTimer();
				this.submitRequest();
			}
		}
		
		private function onExtensionTimeout(evt:TimerEvent):void{
			this.logger.debug('onExtensionTimeout()');
			this.extensionLoadTimeout = true;
			this.disposeExtensionTimer();
			this.submitRequest();
		}
		
		private function disposeExtensionTimer():void{
			this.logger.debug('disposeExtensionTimer()');
			if (this.extTimer){
				this.extTimer.stop();
				this.extTimer.removeEventListener(TimerEvent.TIMER, onExtensionTimeout);
				this.extTimer = null;
			}
			this.am.removeEventListener(this.constants.EVENT_EXTENSION_LOADED, onExtensionLoaded);
		}
		
		private function submitRequest():void{
			if (this.extensionLoadingCount == 0 || this.extensionLoadTimeout){
				this.logger.debug('submitRequest()');
				this.am.addEventListener(this.constants.EVENT_REQUEST_COMPLETE, onRequestComplete);
				this.am.submitRequest();
			}
		}
		
		private function onRequestComplete(e:IEvent):void{
			this.logger.debug('onRequestComplete(' + e.success + ')');
			this.am.removeEventListener(this.constants.EVENT_REQUEST_COMPLETE, onRequestComplete);
			this.requestCompleted = true;
			if (e.success){
				this.storeSlots();
				this.playNonTemporalSlots();
				this.enable = true;
			}
			if (this.startPending){
				this.startPending = false;
				this.start();
			}
		}
		
		public function createSlotElement(slot:ISlot):FWSlotElement{
			return new FWSlotElement(this.am, slot, this.mediator.playerDimension);
		}
		
		private function storeSlots():void{
			this.logger.debug('storeSlots()');
			this.cuePointSlots = new Object();
			this.prerollSlots = [];
			this.postrollSlots = [];
			var fwCuePoints:Array = new Array();
			
			//	var slot:ISlot;
			_orderedAds = new Array();
			_nextCPIndex = 0;
			for each (var slot:ISlot in this.am.getTemporalSlots()){
				var tp:Number = slot.getTimePosition();
				//create cue points according to freewheel response
				if (!useKalturaTemporalSlots) 
				{
					var cp:KalturaAdCuePoint = new KalturaAdCuePoint;
					cp.startTime = tp;
					cp.id = slot.getCustomId();
					cp.tags = cuePointTags;
					cp.protocolType = KalturaAdProtocolType.CUSTOM;
					cp[FROM_FREEWHEEL] = true;
					if (slot.getTimePositionClass()==this.constants.TIME_POSITION_CLASS_OVERLAY)
						cp.adType = KalturaAdType.OVERLAY;
					else
						cp.adType = KalturaAdType.VIDEO;
					
					fwCuePoints.push(cp);
					_cpStatus[cp.id] = CP_NOT_VIEWED;
				}
				
				this.logger.debug('onRequestComplete, temporal slot: ' + slot.getCustomId() + ', tpc:' + slot.getTimePositionClass() + ', tp: ' + tp + ' acceptance: ' + slot.getAcceptance());
				if (slot.getAcceptance() == this.constants.SLOT_ACCEPTANCE_UNKNOWN){
					this.logger.debug('onRequestComplete, skip temporal slot: ' + slot.getCustomId());
					continue;
				}
				switch (slot.getTimePositionClass()){
					case this.constants.TIME_POSITION_CLASS_PREROLL:
						this.prerollSlots.push(this.createSlotElement(slot));
						break;
					case this.constants.TIME_POSITION_CLASS_POSTROLL:
						this.postrollSlots.push(this.createSlotElement(slot));
						break;
					case this.constants.TIME_POSITION_CLASS_MIDROLL:
						if (tp != -1){ // pause ad
							this.cuePointSlots[tp] = slot;
							_orderedAds.push({"tp": tp, "slot":slot});
						}
						break;
					case this.constants.TIME_POSITION_CLASS_OVERLAY:
						this.cuePointSlots[tp] = slot;
						break;
					default:
						break;
				}
			}
			_orderedAds.sortOn("tp", Array.NUMERIC);
			//in case of using freewheel cue points, register them
			if (!useKalturaTemporalSlots) {
				//STAB:
				/*	var cup:KalturaAdCuePoint = new KalturaAdCuePoint();
				cup.id = "preroll";
				cup.startTime = 0;
				cup.adType = KalturaAdType.VIDEO;
				cup.protocolType = KalturaAdProtocolType.CUSTOM;
				cup[FROM_FREEWHEEL] = true;
				fwCuePoints.push(cup);
				var cup1:KalturaAdCuePoint = new KalturaAdCuePoint();
				cup1.id = "midroll";
				cup1.startTime = 13;
				cup1.adType = KalturaAdType.VIDEO;
				cup1.protocolType = KalturaAdProtocolType.CUSTOM;
				cup1[FROM_FREEWHEEL] = true;
				fwCuePoints.push(cup1);
				var cup2:KalturaAdCuePoint = new KalturaAdCuePoint();
				cup2.id = "postroll";
				cup2.startTime = mediaProxy.vo.entry.duration;
				cup2.adType = KalturaAdType.VIDEO;
				cup2.protocolType = KalturaAdProtocolType.CUSTOM;
				cup2[FROM_FREEWHEEL] = true;
				fwCuePoints.push(cup2);*/
				
				
				(facade.retrieveMediator(CuePointsMediator.NAME) as CuePointsMediator).addCuePoints(fwCuePoints);
			}
			this.numPreroll = this.prerollSlots.length;
			this.numPostroll = this.postrollSlots.length;
		}
		
		/**
		 * DEPRECATED
		 * 
		 * resetTimeline: pass a hash of cuePoints in, the plugin will reset its timeline according to that.
		 * 
		 * slots: hash of cuePoints. The keys are slots' time positions, values are ISlots. e.g., {5: <ISlot1>, 10: <ISlot2>}
		 */
		public function resetTimeline(slots:Object = null):void{
			/*this.logger.debug('resetTimeline()');
			var media:MediaElement = this.mediaProxy.vo.media;
			if (!this.timeline && media){
			this.timeline = new FWTimeline(media);
			this.timeline.addEventListener(FWCuePointEvent.CUE_POINT_REACHED, onCuePoint);
			}
			if (!this.timeline)
			return;
			this.timeline.clear(media);
			if (slots != null){
			this.cuePointSlots = slots;
			}
			for (var tp:String in this.cuePointSlots){
			this.timeline.addSlotAsCuepoint(this.cuePointSlots[tp], tp);
			}
			this.logger.debug(this.timeline.toString());*/
		}
		
		public function getSlotByCustomId(customId:String):ISlot {
			return this.am.getSlotByCustomId(customId);
		}
		
		public function onCuePoint(cuePoint:KalturaAdCuePoint):void{
			var slot:ISlot = this.am.getSlotByCustomId(cuePoint.id);
			if (!slot)
				return;
			this.logger.debug('onCuePoint(' + slot.getTimePosition() + ')');
			
			if (cuePoint.adType==KalturaAdType.VIDEO) {
				if (playAdsByOrder) {
					if (_cpStatus[cuePoint.id]==CP_VIEWED)
						return;
					
					slot= _orderedAds[_nextCPIndex].slot;
					_nextCPIndex++;
					_cpStatus[cuePoint.id] = CP_VIEWED;
				}
				//this.mediator.sendNotification( NotificationType.DO_PAUSE );
				this.midrollArr.push(slot);
				sequenceProxy.vo.midrollArr.push(this);
			}
			else {
				this.mediator.playSlotElement(this.createSlotElement(slot));
			}
		}
		
		
		private function playNonTemporalSlots():void{
			this.logger.debug('playNonTemporalSlots()');
			var slot:ISlot;
			for each (slot in this.am.getSiteSectionNonTemporalSlots()){
				this.logger.debug('Play SSNT slot: ' + slot.getCustomId());
				slot.play();
			}
			for each (slot in this.am.getVideoPlayerNonTemporalSlots()){
				this.logger.debug('Play VPNT slot: ' + slot.getCustomId());
				slot.play();
			}
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
			// Do nothing here
		}
		
		private function get nextPreroll():FWSlotElement{
			if (this.numPreroll){
				return this.prerollSlots[this.prerollSlots.length - this.numPreroll];
			}
			else return null;
		}
		
		public function playNextPrerollSlot():void{
			this.logger.debug('playNextPrerollSlot(), numPreroll:' + this.numPreroll);
			if (this.numPreroll){
				var next:FWSlotElement = this.nextPreroll;
				this.numPreroll -= 1;
				this.mediator.playSlotElement(next);
			}
			else{
				this.logger.debug('No more preroll slots to be played.');
				this.sequenceProxy.sendNotification(NotificationType.SEQUENCE_ITEM_PLAY_END, {sequenceContext : this.sequenceProxy.sequenceContext, currentIndex : this.sequenceProxy.vo.preCurrentIndex});
			}
		}
		
		private function get nextPostroll():FWSlotElement{
			if (this.numPostroll){
				return this.postrollSlots[this.postrollSlots.length - this.numPostroll];
			}
			else return null;
		}
		
		private function playNextPostrollSlot():void{
			this.logger.debug('playNextPostrollSlot(), numPostroll:' + this.numPostroll);
			if (this.numPostroll){
				var next:FWSlotElement = this.nextPostroll;
				this.numPostroll -= 1;
				this.mediator.playSlotElement(next);
			}
			else{
				this.logger.debug('No more postroll slots to be played.');
				this.sequenceProxy.sendNotification(NotificationType.SEQUENCE_ITEM_PLAY_END, {sequenceContext : this.sequenceProxy.sequenceContext, currentIndex : this.sequenceProxy.vo.postCurrentIndex});
			}
		}
		
		/**
		 * Function to start playing the plugin content - each plugin implements this differently
		 * 
		 */		
		public function start() : void {
			this.logger.debug('start()');
			
			if (!this.enable){
				this.logger.debug('Plugin not enabled, something went wrong.');
				this.sequenceProxy.sendNotification(NotificationType.SEQUENCE_ITEM_PLAY_END);
				return;
			}
			
			if (!this.requestCompleted){
				this.logger.debug('request not completed, start pending');
				this.startPending = true;
				return;
			}
			
			
			// the following strange logic is used to ensure the correct KDP workflow
			// when there's no ad in a linear slot.
			if (this.mediator.sequenceContext == SequenceContextType.PRE){
				if (this.nextPreroll && this.nextPreroll.numAds == 0){
					setTimeout(playNextPrerollSlot, 0);
				}
				else{
					this.playNextPrerollSlot();
				}
			}
			else if (this.mediator.sequenceContext == SequenceContextType.POST){
				if (this.nextPostroll && this.nextPostroll.numAds == 0){
					setTimeout(playNextPostrollSlot, 0);
				}
				else{
					this.playNextPostrollSlot();
				}
			}
			else if (this.mediator.sequenceContext == SequenceContextType.MID && this.midrollArr && this.midrollArr.length) {
				this.mediator.playSlotElement(this.createSlotElement(this.midrollArr[0] as ISlot));
				this.midrollArr.shift();
			}
		}
		
		/**
		 * Function returns whether the plugin in question has a sub-sequence 
		 * @return The function returns true if the plugin has a sub-sequence, false otherwise.
		 * 
		 */		
		public function hasSubSequence() : Boolean {
			this.logger.debug('hasSubsequence()');
			if (this.mediator.sequenceContext == SequenceContextType.PRE){
				return this.numPreroll > 0;
			}
			if (this.mediator.sequenceContext == SequenceContextType.POST){
				return this.numPostroll > 0;
			}
			// if we replay pre/postroll slots, set numPreroll = this.prerollSlots.length again when this func returns false;			
			return false;
		}
		
		/**
		 * Function returns the length of the sub-sequence length of the plugin 
		 * @return The function returns an integer signifying the length of the sub-sequence;
		 * 			If the plugin has no sub-sequence, the return value is 0.
		 */		
		public function subSequenceLength () : int {
			this.logger.debug('subSequenceLength()');
			if (this.mediator.sequenceContext == SequenceContextType.PRE){
				return this.numPreroll;
			}
			if (this.mediator.sequenceContext == SequenceContextType.POST){
				return this.numPostroll;
			}
			return 0;
		}
		
		/**
		 * Returns whether the Sequence Plugin plays within the KDP or loads its own media over it. 
		 * @return The function returns <code>true</code> if the plugin media plays within the KDP
		 *  and <code>false</code> otherwise.
		 * 
		 */		
		public function hasMediaElement () : Boolean {
			return true;
		}
		
		/**
		 * Function for retrieving the entry id of the plugin media
		 * @return The function returns the entry id of the plugin media. If the plugin does not play
		 * 			a kaltura-based entry, the return value is the URL of the media of the plugin.
		 */		
		public function get entryId () : String {
			return null;
		}
		
		/**
		 * Function for retrieving the source type of the plugin media (url or entryId) 
		 * @return If the plugin plays a Kaltura-Based entry the function returns <code>entryId</script>.
		 * Otherwise the return value is <code>url</script>
		 * 
		 */		
		public function get sourceType () : String {
			return "url";
		}
		/**
		 * Function to retrieve the MediaElement the plugin will play in the KDP. 
		 * @return returns the MediaElement that the plugin will play in the KDP. 
		 * 
		 */		
		public function get mediaElement () : Object {
			this.logger.debug('mediaElement()');
			return 1;
		}
		
		/**
		 * Function for determining where to place the ad in the pre sequence; 
		 * @return The function returns the index of the plugin in the pre sequence; 
		 * 			if the plugin should not appear in the pre-sequence, return value is -1.
		 */		
		public function get preIndex () : Number {
			return preSequence;
		}
		
		/**
		 *Function for determining where to place the plugin in the post-sequence. 
		 * @return The function returns the index of the plugin in the post-sequence;
		 * 			if the plugin should not appear in the post-sequence, return value is -1.
		 */		
		public function get postIndex () : Number {
			return postSequence;
		}
		//////// Implement ISequencePlugin methods, end
		
		public function hasMidroll():Boolean{
			this.logger.debug('hasMidroll()');
			for (var tp:String in this.cuePointSlots){
				try
				{
					if (this.cuePointSlots[tp].timePositionClass == this.constants.TIME_POSITION_CLASS_MIDROLL){
						return true;
					}
				} 
				catch(error:Error) 
				{
				}
			}
			return false;

		}
		
		public function get midrollMediaElement():MediaElement{
			this.logger.debug('midrollMediaElement()');
			return null;
		}
		
		// exposed admanager methods
		public function setAdVolume(volume:Number):void{
			this.logger.debug('setAdVolume(' + volume * 100 + ')');
			this.adVolume = int(volume * 100);
			if (this.am)
				this.am.setAdVolume(this.adVolume);
		}
		
		public function updatePlayerStatus(status:String):void{
			this.logger.debug('updatePlayerStatus(' + status + ')');
			if (this.am){
				switch (status){
					case 'paused':
						this.am.setVideoPlayStatus(this.constants.VIDEO_STATUS_PAUSED);
						break;
					case 'playing':
						this.am.setVideoPlayStatus(this.constants.VIDEO_STATUS_PLAYING);
						break;
					case 'stopped':
						this.am.setVideoPlayStatus(this.constants.VIDEO_STATUS_STOPPED);
						break;
					default:
						break;
					
				}
			}
		}
		
		public function set adManagerUrl(v:String):void{
			this.parameters.uiConf[FreeWheelParameters.PARAM_ADMANAGER_URL] = v;
		}
		
		public function set serverUrl(v:String):void{
			this.parameters.uiConf[FreeWheelParameters.PARAM_SERVER_URL] = v;
		}
		
		public function set networkId(v:String):void{
			this.parameters.uiConf[FreeWheelParameters.PARAM_NETWORK_ID] = v;
		}
		
		public function set playerProfile(v:String):void{
			this.parameters.uiConf[FreeWheelParameters.PARAM_PLAYER_PROFILE] = v;
		}
		
		public function set videoAssetId(v:String):void{
			trace ("freewheel: video id is: " ,v);
			this.parameters.uiConf[FreeWheelParameters.PARAM_VIDEO_ASSET_ID] = v;
		}
		
		public function set videoAssetIdType(v:String):void{
			this.parameters.uiConf[FreeWheelParameters.PARAM_VIDEO_ASSET_ID_TYPE] = v;
		}
		
		public function set videoAssetFallbackId(v:String):void{
			this.parameters.uiConf[FreeWheelParameters.PARAM_VIDEO_ASSET_FALLBACK_ID] = v;
		}
		
		public function set videoAssetNetworkId(v:String):void{
			this.parameters.uiConf[FreeWheelParameters.PARAM_VIDEO_ASSET_NETWORK_ID] = v;
		}
		
		public function set siteSectionId(v:String):void{
			this.parameters.uiConf[FreeWheelParameters.PARAM_SITE_SECTION_ID] = v;
		}
		
		public function set siteSectionIdType(v:String):void{
			this.parameters.uiConf[FreeWheelParameters.PARAM_SITE_SECTION_ID_TYPE] = v;
		}
		
		public function set siteSectionFallbackId(v:String):void{
			this.parameters.uiConf[FreeWheelParameters.PARAM_SITE_SECTION_FALLBACK_ID] = v;
		}
		
		public function set siteSectionNetworkId(v:String):void{
			this.parameters.uiConf[FreeWheelParameters.PARAM_SITE_SECTION_NETWORK_ID] = v;
		}
		
		public function set rendererConfiguration(v:String):void{
			this.parameters.uiConf[FreeWheelParameters.PARAM_RENDERER_CONFIGURAION] = v;
		}
		
		public function set capabilities(v:String):void{
			this.parameters.uiConf[FreeWheelParameters.PARAM_CAPABILITIES] = v;
		}
		
		public function set keyValues(v:String):void{
			this.parameters.uiConf[FreeWheelParameters.PARAM_KEY_VALUES] = v;
		}
		
		public function set overrideParameters(v:String):void{
			this.parameters.uiConf[FreeWheelParameters.PARAM_OVERRIDE_PARAMETERS] = v;
		}
		
		public function set extensions(v:String):void{
			this.parameters.uiConf[FreeWheelParameters.PARAM_EXTENSIONS] = v;
		}
		
		
		public function set replayTimePositionClasses(v:String):void{
			this.parameters.uiConf[FreeWheelParameters.PARAM_REPLAY_TIME_POSITION_CLASSES] = v;
		}
		
		public function get userPauseNotificationName():String{
			return this.parameters.userPauseNotificationName;
		}
		
		[Bindable]
		public function set overlays(value:Object):void {
			_overlays = value;
		}
		
		public function get overlays():Object {
			return _overlays;
		}
		
		//ad manager interface
		
		public function adTemporalSlot(customId:String, adUnit:String, timePosition:Number, slotProfile:String=null, timePositionSequence:uint=0, maxDuration:Number=0, slotParameters:Object=null, acceptPrimaryContentType:String=null, acceptContentType:String=null, minDuration:Number=0, cuePointSequence:uint=0, slotBase:Sprite=null):ISlot {
			return am.addTemporalSlot(customId, adUnit, timePosition, slotProfile, timePositionSequence, maxDuration, slotParameters, acceptPrimaryContentType, acceptContentType
				, minDuration, cuePointSequence, slotBase);
		}
		
		public function addRenderer(url:String, baseUnit:String = null, contentType:String = null, slotType:String = null, adUnit:String = null, parameters:Object = null, creativeAPI:String = null):void {
			am.addRenderer(url, baseUnit, contentType, slotType, adUnit, parameters, creativeAPI);
			
		}
		
		public function addVideoPlayerNonTemporalSlot(customId:String, slotBase:Sprite, slotWidth:uint, slotHeight:uint, slotProfile:String = null, slotX:int = 0, slotY:int = 0, acceptCompanion:Boolean = true, adUnit:String = null, slotParameters:Object = null, acceptPromaryContentType:String = null, acceptContentType:String = null, initalAdOption:* = null, compatibleDimensions:Array = null):ISlot {
			return am.addVideoPlayerNonTemporalSlot(customId, slotBase, slotWidth, slotHeight, slotProfile, slotX, slotY, acceptCompanion, adUnit, slotParameters, acceptPromaryContentType, acceptContentType, initalAdOption, compatibleDimensions);
		}
		
	}
}
