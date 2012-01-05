package tv.freewheel.wrapper.kaltura
{
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.AdsNotificationTypes;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.SequenceContextType;
	import com.kaltura.kdpfl.model.vo.AdMetadataVO;
	import com.kaltura.kdpfl.plugin.IMidrollSequencePlugin;
	import com.kaltura.kdpfl.view.controls.KTrace;
	import com.kaltura.kdpfl.view.media.KMediaPlayer;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	import com.kaltura.osmf.proxy.KSwitchingProxyElement;
	import com.kaltura.puremvc.as3.patterns.mediator.SequenceMultiMediator;
	import com.kaltura.types.KalturaAdProtocolType;
	import com.kaltura.vo.KalturaAdCuePoint;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.profiler.showRedrawRegions;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import org.osmf.elements.SWFElement;
	import org.osmf.events.MediaElementEvent;
	import org.osmf.events.MediaPlayerCapabilityChangeEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.URLResource;
	import org.osmf.traits.DisplayObjectTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayTrait;
	import org.osmf.traits.TimeTrait;
	import org.puremvc.as3.interfaces.INotification;
	
	import tv.freewheel.ad.behavior.ISlot;
	import tv.freewheel.logging.Logger;
	import tv.freewheel.playerextension.kdpanalytics.AdInfo;
	import tv.freewheel.playerextension.kdpanalytics.CustomEvent;
	import tv.freewheel.renderer.util.StringUtil;
	import tv.freewheel.wrapper.kaltura.events.SeekEvent;
	import tv.freewheel.wrapper.osmf.events.FWScrubEvent;
	import tv.freewheel.wrapper.osmf.events.FWSlotEvent;
	import tv.freewheel.wrapper.osmf.slot.FWSlotElement;
	
	/**
	 * Mediator is for interacting with KDP player
	 */
	public class FreeWheelMediator extends SequenceMultiMediator 
	{
		public static var NAME:String = "FreeWheelMediator";
		public static const ADVERTISER_NAME:String ="Freewheel";
		public static const INTERACTIVE_AD_CLICKED:String = "interactiveAdClicked";
		public static const END_INTERACTIVE_AD:String = "endInteractiveEnd";
		public static const FIXED_SIZE_INTERACTIVE:String = "fixed-size-interactive";
		public static const LINEAR_ANIMATION:String = "linear-animation";
		public static const UPDATE_VIDEO_ASSET_ID:String = "updateVideoAssetId";
		public static const FW_ADVERTISER_NAME_KEY:String = "_fw_advertiser_name";
		
		private var logger:Logger;
		
		private var plugin:freeWheelPluginCode;
		public var slotBase:SlotBase;
		
		private var _playerMediator:KMediaPlayerMediator;
		private var _player:KMediaPlayer;
		
		private var playhead:Number;
		private var seekTo:Number;
		
		private var waitingForMetadata:Boolean = false;
		public var waitingForCuePoints:Boolean = false;
		private var playingLeader:Boolean = false;
		
		public var entryMetadata:Object;
		public var entryCuePoints:Object;
		
		private var _sequenceProxy:SequenceProxy;
		//flags to identify ad progress
		private var _reached25:Boolean = false;
		private var _reached50:Boolean = false;
		private var _reached75:Boolean = false;
		
		private var _adMetadataVo:AdMetadataVO;
		
		private var _interactiveTimer:Timer;
		
		public function FreeWheelMediator(pluginCode:freeWheelPluginCode, viewComponent:Object = null)
		{
			this.logger = Logger.getSimpleLogger('KDPPlugin.Mediator ');
			this.logger.debug('new FreeWheelMediator()');
			super(viewComponent);
			this.plugin = pluginCode;
			_sequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
		}
		
		override public function listNotificationInterests():Array{
			return [
				NotificationType.MEDIA_READY,
				NotificationType.ENTRY_READY,
				NotificationType.LAYOUT_READY,
				NotificationType.VOLUME_CHANGED,
				NotificationType.PLAYER_UPDATE_PLAYHEAD,
				NotificationType.HAS_OPENED_FULL_SCREEN,
				NotificationType.HAS_CLOSED_FULL_SCREEN,
				NotificationType.ROOT_RESIZE,
				NotificationType.PLAYER_STATE_CHANGE,
				NotificationType.PLAYER_SEEK_START,
				NotificationType.PLAYER_SEEK_END,
				NotificationType.INTELLI_SEEK,
				NotificationType.SEQUENCE_SKIP_NEXT,
				NotificationType.METADATA_RECEIVED,
				NotificationType.CUE_POINTS_RECEIVED,
				NotificationType.AD_OPPORTUNITY,
				this.plugin.userPauseNotificationName,
				END_INTERACTIVE_AD,
				NotificationType.SEQUENCE_ITEM_PLAY_END,
				UPDATE_VIDEO_ASSET_ID
			];
		}
		
		override public function handleNotification(notification:INotification):void{
			this.logger.debug('handleNotification(' + notification.getName() + ':' + StringUtil.objectToString(notification.getBody()) + ')');
			switch (notification.getName()){
				case NotificationType.MEDIA_READY:
					this.handleMediaReady();
					break;
				case NotificationType.ENTRY_READY:
					if (!_sequenceProxy.vo.isInSequence)
						this.handleEntryReady(notification.getBody());
					break;
				case NotificationType.LAYOUT_READY:
					this.handleLayoutReady(notification.getBody());
					break;
				case NotificationType.VOLUME_CHANGED:
					this.plugin.setAdVolume(Number(notification.getBody().newVolume));
					break;
				case NotificationType.PLAYER_UPDATE_PLAYHEAD:
					this.handlePlayhead(notification.getBody() as Number);
					break;
				case NotificationType.HAS_OPENED_FULL_SCREEN:
				case NotificationType.HAS_CLOSED_FULL_SCREEN:
				case NotificationType.ROOT_RESIZE:
					flash.utils.setTimeout(this.plugin.resize, 1);
					break;
				case NotificationType.PLAYER_STATE_CHANGE:
					//if (!this.playingLeader){
					//	this.enableGui(true);
						this.plugin.updatePlayerStatus(notification.getBody().toString());
					//}
					break;
				case NotificationType.PLAYER_SEEK_START:
					this.handleSeekStart();
					break;
				case NotificationType.PLAYER_SEEK_END:
					this.handleSeekEnd();
					break;
				case NotificationType.INTELLI_SEEK:
					this.seekTo = Number(notification.getBody()['intelliseekTo']);
					break;
				case NotificationType.SEQUENCE_SKIP_NEXT:
					this.reset();
					break;
				case NotificationType.METADATA_RECEIVED:
					if (!_sequenceProxy.vo.isInSequence)
						this.handleMetadata(notification.getBody());
					break;
				case NotificationType.CUE_POINTS_RECEIVED:
					this.hanleCuePoints(notification.getBody());
					break;
				case NotificationType.AD_OPPORTUNITY:
					var adContext : String = notification.getBody().context;
					var cuePoint:KalturaAdCuePoint = notification.getBody().cuePoint as KalturaAdCuePoint;
					if (this.plugin.useKalturaTemporalSlots || cuePoint[freeWheelPluginCode.FROM_FREEWHEEL])
					{
						if (cuePoint.protocolType == KalturaAdProtocolType.CUSTOM) {
							if (adContext== SequenceContextType.PRE)
								_sequenceProxy.vo.preSequenceArr.push(plugin);
							else if (adContext== SequenceContextType.POST)
								_sequenceProxy.vo.postSequenceArr.push(plugin);
							else
								plugin.onCuePoint(cuePoint);
						}
					}
					
					break;
				case this.plugin.userPauseNotificationName:
					if (player.player.paused){
						this.handleUserPause();
					}
					break;
				case END_INTERACTIVE_AD:
					playerMediator.kMediaPlayer.removeEventListener(MouseEvent.CLICK, onInteractiveClick);
					endSlot();
					break;
				
				case NotificationType.SEQUENCE_ITEM_PLAY_END:
					if (this.playingLeader)
						this.playingLeader = false;
					break;

				case UPDATE_VIDEO_ASSET_ID:
					this.plugin.videoAssetId = notification.getBody().videoAssetId;
					break;
			}
		}
		
		public function playSlotElement(slot:FWSlotElement):void{
			this.logger.debug('playSlotElement(' + slot.customId + ')');
			
			if (!this.player.parent.contains(this.slotBase))
				this.player.parent.addChild(this.slotBase);
			
			slot.addEventListener(FWSlotEvent.SLOT_END, onSlotEnd);
			
			if (slot.timePositionClass == this.plugin.constants.TIME_POSITION_CLASS_PREROLL ||
				slot.timePositionClass == this.plugin.constants.TIME_POSITION_CLASS_POSTROLL ||
				slot.timePositionClass == this.plugin.constants.TIME_POSITION_CLASS_MIDROLL)
			{
				populateAdMetadataVo(slot);
			}
			
			switch (slot.timePositionClass){
				case this.plugin.constants.TIME_POSITION_CLASS_PREROLL:
				case this.plugin.constants.TIME_POSITION_CLASS_POSTROLL:
					this.playPrePostroll(slot);
					break;
				case this.plugin.constants.TIME_POSITION_CLASS_MIDROLL:
					this.playMidroll(slot);
					break;
				case this.plugin.constants.TIME_POSITION_CLASS_OVERLAY:
					this.playOverlay(slot);
					break;
			}
		
		}
		
		private function playPrePostroll(slot:FWSlotElement):void{
			var mediaElement:MediaElement;
			if (plugin.currentBaseUnit == FIXED_SIZE_INTERACTIVE || plugin.currentBaseUnit == LINEAR_ANIMATION) 
			{
				mediaElement = prepareSwfElement(slot);
			}
			else
			{
				mediaElement = slot;				
			}
			
			if(_sequenceProxy.setPrePostMedia(mediaElement))
			{
				this.playingLeader = true;
			}
			
		}
		
		private function playMidroll(slot:FWSlotElement):void{
			var mediaElement:MediaElement;
			if (plugin.currentBaseUnit == FIXED_SIZE_INTERACTIVE || plugin.currentBaseUnit == LINEAR_ANIMATION) 
			{
				mediaElement = prepareSwfElement(slot);
			}
			else {
				mediaElement= slot;
			}
			if (_sequenceProxy.switchElementForMidroll(mediaElement)) 
			{
				this.playingLeader = true;
			}
		}
		
		/**
		 * create swf element and add relevant listeners
		 * */
		private function prepareSwfElement(slot:FWSlotElement):SWFElement {
			var swfElement:SWFElement = new SWFElement(new URLResource(_adMetadataVo.url));
			_interactiveTimer = new Timer(slot.duration * 1000, 1);
			swfElement.addEventListener(MediaElementEvent.TRAIT_ADD, onTraitAdd);
			playerMediator.kMediaPlayer.addEventListener(MouseEvent.CLICK, onInteractiveClick);
			return swfElement;
		}
		
		private function onInteractiveAdEnd(event:TimerEvent):void {
			_interactiveTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onInteractiveAdEnd);
			if (this.plugin.autoContinue) {
				playerMediator.kMediaPlayer.removeEventListener(MouseEvent.CLICK, onInteractiveClick);
				endSlot();
			}
		}
		
		private function endSlot():void {
			this.playingLeader = false;
			_sequenceProxy.vo.activePluginMetadata = null;
			_adMetadataVo = null;
			resetAdParams();
			this.enableGui(true);
			_sequenceProxy.vo.isAdLoaded = false;
			this.sendNotification(AdsNotificationTypes.AD_END, {timeSlot: this.sequenceContext});
			
			if (this.sequenceContext==SequenceContextType.MID)
				this.sendNotification(NotificationType.SEQUENCE_ITEM_PLAY_END, {sequenceContext : this.sequenceContext, currentIndex : _sequenceProxy.vo.midCurrentIndex});
			else
				this.plugin.playNextPrerollSlot();
			

		}
		
		private function onTraitAdd(evt:MediaElementEvent):void {
			if (evt.traitType==MediaTraitType.DISPLAY_OBJECT) {
				evt.target.removeEventListener(MediaElementEvent.TRAIT_ADD, onTraitAdd);
				_interactiveTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onInteractiveAdEnd);
				_interactiveTimer.start();
			}
		}
		
		private function populateAdMetadataVo(slot:FWSlotElement):void {
			if (!slot.customId)
				return;
			_adMetadataVo = new AdMetadataVO();
			_adMetadataVo.duration = slot.duration;
			_adMetadataVo.id = slot.customId;
			_adMetadataVo.type = slot.timePositionClass;
			_adMetadataVo.width = (slot.slot as ISlot).getWidth();
			_adMetadataVo.height = (slot.slot as ISlot).getHeight();
			_adMetadataVo.name = ADVERTISER_NAME;
			this.plugin.currentBaseUnit = '';
			var creative:Object = getNestedCreative(slot);
			if (creative) {
				this.plugin.currentBaseUnit = creative.adUnit;
				var creatives:Array = creative.creativeRenditions;
				if (creatives && creatives.length) {
					_adMetadataVo.url = creatives[0].asset.url;
					_adMetadataVo.mimeType = creatives[0].asset.mimeType;
					_adMetadataVo.title = creatives[0].asset.name;		
				}	
				var parametersArr:Array = creative.parameters;
				if (parametersArr)
				{
					for (var i:int = 0; i< parametersArr.length; i++) 
					{
						if (parametersArr[i].name && (parametersArr[i].name == FW_ADVERTISER_NAME_KEY))
						{
							_adMetadataVo.advertiser = parametersArr[i].value;
							break;
						}
					}
				}
				
			}
		
			_sequenceProxy.vo.activePluginMetadata = _adMetadataVo;
		}
		
		private function getNestedCreative(slot:FWSlotElement):Object {
			var adInstances:Array = slot.slot.getAdInstances();
			if (adInstances && adInstances.length) {
				var references:Array = adInstances[0].slot.adReferences;
				if (references && references.length) {
					return references[0].creative;			
				}
			}
			return null;	
		}
		
		private function onAdDurationReceived (e : TimeEvent) : void
		{
			if (e.time > 0 && !isNaN(e.time))
			{
				_sequenceProxy.vo.timeRemaining = Math.round(e.time);
				_sequenceProxy.vo.isAdLoaded = true;
				(e.target as MediaPlayer).removeEventListener(TimeEvent.DURATION_CHANGE, onAdDurationReceived );
			}
		}
		
		private function playOverlay(slot:FWSlotElement):void{
			this.logger.debug('playOverlay(' + slot.customId + ')');
			slot.slot.setBase(this.slotBase);
			slot.play();
			
			var creative:Object = getNestedCreative(slot);
			if (creative) {
				this.plugin.currentBaseUnit = creative.adUnit;
				var creatives:Array = creative.creativeRenditions;
				var clickThru:String = getClickThrough(slot);
				if (creatives && creatives.length) 
				{
					sendNotification ("changeOverlayDisplayDuration" , {newDuration : creatives[0].creative.duration})
					var overlayObj:Object  = {
						"nonLinearResource": 		creatives[0].asset.url,
						"nonLinearClickThrough":	clickThru,
						"trackingEvents": 			{}
					};
					plugin.overlays = new Array(overlayObj);
					sendNotification ("showOverlayOnCuePoint");			
				}	
			}		
		}
		
		/**
		 * finds the clickThrou url from the given slot
		 * */
		private function getClickThrough(slot:FWSlotElement):String {
			var clickThru:String;
			
			var adInstances:Array = slot.slot.getAdInstances();
			if (adInstances && adInstances.length) {
				var references:Array = adInstances[0].slot.adReferences;
				if (references && references.length) {
					var events:Array = references[0].eventCallbacks;
					if (events && events.length) {
						for (var i:int = 0; i<events.length; i++) {
							if (events[i].name == "defaultClick") 
							{
								clickThru = events[i].url;
								break;
							}
						}
					}
				}
			}
			
			return clickThru;
		}
		
		private function onInteractiveClick(evt:Event):void {
			sendNotification(INTERACTIVE_AD_CLICKED);
		}
		
		private function stopOverlay(customId:String):void {
			var slot:ISlot = this.plugin.getSlotByCustomId(customId);
			if (slot) {
				slot.stop();
			}
		}
		
		private function onSlotEnd(evt:FWSlotEvent):void{
			this.logger.debug('onSlotEnd('+evt.slotElement.customId+')');
			
			var slotElement:FWSlotElement = evt.slotElement;
			slotElement.removeEventListener(FWSlotEvent.SLOT_END, onSlotEnd);
			if ([this.plugin.constants.TIME_POSITION_CLASS_PREROLL,
				this.plugin.constants.TIME_POSITION_CLASS_MIDROLL,
				this.plugin.constants.TIME_POSITION_CLASS_POSTROLL].indexOf(slotElement.timePositionClass) > -1)
			{
				this.playingLeader = false;
				_sequenceProxy.vo.activePluginMetadata = null;
				_adMetadataVo = null;
				resetAdParams();
			}	
		}
		
		private function handleMediaReady():void{
			this.logger.debug('handleMediaReady()');
		}
		
		private function handleEntryReady(obj:Object):void{
			this.logger.debug('handleEntryReady()');
			this.entryMetadata = (this.facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.entryMetadata;
			this.entryCuePoints = (this.facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.entryCuePoints;
			this.logger.debug('entryMetadata: ' + StringUtil.objectToString(this.entryMetadata));
			this.logger.debug('entryCuePoints: ' + StringUtil.objectToString(this.entryCuePoints));
			
			if (this.shouldWaitForMetadata){
				this.logger.debug('should wait for metadata to arrive before notifying entry ready.');
				this.waitingForMetadata = true;
				setTimeout(this.dataTimeout, 3000);
			}
			else if (this.shouldWaitForCuePoints) {
				this.logger.debug('should wait for cue points to arrive before notifying entry ready.');
				this.waitingForCuePoints = true;
				setTimeout(this.dataTimeout, 3000);
			}
			else{
				this.plugin.notifyEntryReady();
				this.waitingForMetadata = false;
				this.waitingForCuePoints = false;
			}
		}
		
		private function dataTimeout():void{
			if (this.waitingForMetadata){
				this.logger.debug("metadataTimeout()");
				waitingForMetadata = false;
				this.entryMetadata = null;
				this.plugin.notifyEntryReady();
			}
			else if (this.waitingForCuePoints) {
				this.logger.debug("cuePointsTimeout()");
				waitingForCuePoints = false;
				this.entryCuePoints = null;
				this.plugin.notifyEntryReady();
			}
		}
		
		
		private function handleMetadata(meta:Object):void{
			this.logger.debug('handleMetadata(' + StringUtil.objectToString((this.facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.entryMetadata) + ')');
			if (this.waitingForMetadata){
				this.logger.debug('This is the entry metadata we are expecting for.');
				this.entryMetadata = (this.facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.entryMetadata;
				this.logger.debug(StringUtil.objectToString(this.entryMetadata));
				this.waitingForMetadata = false;
				if (!this.waitingForCuePoints)
					this.plugin.notifyEntryReady();
			}
		}
		
		private function hanleCuePoints(cuePoints:Object):void {
			this.logger.debug('handleCuePoints(' + StringUtil.objectToString((this.facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.entryCuePoints) + ')');
			if (this.waitingForCuePoints) {
				this.logger.debug('This is the entry cue points we are expecting for.');
				this.entryCuePoints = (this.facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.entryCuePoints;
				this.logger.debug(StringUtil.objectToString(this.entryCuePoints));
				this.waitingForCuePoints = false;
				if (!this.waitingForMetadata)
					this.plugin.notifyEntryReady();
			}
		}
		
		public function reset():void{
			this.logger.debug('reset()');
			this.resetSlotBase();
			this.enableGui(true);
		}
		
		private function handleLayoutReady(notifObj:Object):void{
			this.logger.debug('handleLayoutReady()');
			this.resetSlotBase();
		}
		
		private function resetSlotBase():void{
			this.logger.debug('resetSlotBase()');
			if (!this.slotBase){
				this.slotBase = new SlotBase();
				this.slotBase.addEventListener('adStart', onAnalyticsEvent);
				this.slotBase.addEventListener('adProgress', onAnalyticsEvent);
				this.slotBase.addEventListener('adComplete', onAnalyticsEvent);
				this.slotBase.addEventListener('adInfoAdded', onAdInfoAdded);
				this.slotBase.addEventListener('adClick', onAnalyticsEvent);
				this.slotBase.addEventListener('podComplete', onAnalyticsEvent);
				this.slotBase.addEventListener('podStart', onAnalyticsEvent);
				this.slotBase.addEventListener('pauseAdCompleted', onPauseAdCompleted);
				this.slotBase.addEventListener(FWScrubEvent.SCRUB_END, onScrubEnd);
			}
			
			if (this.player && !this.player.parent.contains(this.slotBase)){
				this.player.parent.addChild(this.slotBase);
			}
			
			for (var i:int = 0; i < this.slotBase.numChildren; i++){
				this.slotBase.removeChildAt(i);
			}
		}
		
		private function onPauseAdCompleted(evt:Event):void{
			this.logger.debug('onPauseAdCompleted()');
			this.sendNotification(NotificationType.DO_PLAY);
		}
		
		private function onAnalyticsEvent(evt:Event):void{
			this.logger.debug('onAnalyticsEvent(' + evt.type + ')');
			this.sendNotification('FDMAnalytics.' + evt.type, evt['info']);
		}
		
		private function onAdInfoAdded(evt:Event):void {
		}
		
		private function handleSeekStart():void{
			this.logger.debug('handleSeekStart(' + this.getPlayheadTime() + ')');
			this.seekTo = NaN;
			var evt:SeekEvent = new SeekEvent(SeekEvent.SEEK_START);
			evt.data = this.getPlayheadTime();
			this.slotBase.dispatchEvent(evt);
		}
		
		private function handleSeekEnd():void{
			this.logger.debug('handleSeekEnd(' + this.getPlayheadTime() + ')');
			this.seekTo = this.seekTo || this.getPlayheadTime();
			if (isNaN(this.seekTo)){
				this.logger.debug('seekTo NaN, return');
				return;
			}
			var evt:SeekEvent = new SeekEvent(SeekEvent.SEEK_END);
			evt.data = {'seekTo': this.seekTo, 'videoLength': this._playerMediator.player.duration};
			this.slotBase.dispatchEvent(evt);
		}
		
		private function onScrubEnd(evt:FWScrubEvent):void{
			this.logger.debug('onScrubEnd()');
			if (evt.slot){
				this.playSlotElement(this.plugin.createSlotElement(evt.slot as ISlot));
			}
		}
		
		private function handleUserPause():void{
			this.logger.debug('handleUserPause()');
			if (this.slotBase)
				this.slotBase.dispatchEvent(new Event('pauseButtonClicked'));
		}
		
		private function handlePlayhead(playhead:Number):void{
			this.logger.debug('handlePlayhead(' + playhead + '), playing leader ? ' + this.playingLeader);
			if (!this.playingLeader){
				this.playhead = playhead;
			}
			else {
				var duration:Number = (facade.retrieveMediator("kMediaPlayerMediator"))["player"]["duration"];
				var fraction:Number = playhead / duration;
				if (!_reached25 && fraction > 0.25) {
					sendNotification(AdsNotificationTypes.FIRST_QUARTILE_OF_AD, {timeSlot: this.sequenceContext});
					_reached25 = true;
				}
				else if (!_reached50 && fraction > 0.5){
					sendNotification(AdsNotificationTypes.MID_OF_AD, {timeSlot:this.sequenceContext});
					_reached50 = true;
				}
				else if (!_reached75 && fraction > 0.75){
					sendNotification(AdsNotificationTypes.THIRD_QUARTILE_OF_AD, {timeSlot:this.sequenceContext});
					_reached75 = true;	
				}
			}
		}
		
		/**
		 * resets the "reached" variables. 
		 * used when we have more than 1 ad.
		 */		
		public function resetAdParams():void {
			_reached25 = false;
			_reached50 = false;
			_reached75 = false;
		}
		
		public function getPlayheadTime():Number{
			if (this.playingLeader){
				return this.playhead;
			}
			else{
				var mediaProxy:MediaProxy = this.facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
				if (mediaProxy && mediaProxy.vo.media && mediaProxy.vo.media.getTrait(MediaTraitType.TIME)){
					return (mediaProxy.vo.media.getTrait(MediaTraitType.TIME) as TimeTrait).currentTime;
				}
				else{
					return this.playhead;
				}
			}
		}
		
		public function enableGui(enabled:Boolean):void{
			this.logger.debug("enableGui(" + enabled + ")");
			this.sendNotification('enableGui', {guiEnabled: enabled, enableType: 'full'});
			// volume bar stays enabled all the time.
			try{
				this.facade['bindObject']['volumeBar'].enabled = true;
			}
			catch (e:Error){
				this.logger.warn('Enabling volumeBar caught error: ' + e.toString());
			}
		}
		
		private function get player():KMediaPlayer{
			if (!this._player && this.playerMediator){
				this._player = this.playerMediator.kMediaPlayer;
			}
			return this._player;
		}
		
		private function get playerMediator():KMediaPlayerMediator{
			if (!this._playerMediator)
				this._playerMediator = this.facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator;
			return this._playerMediator;
		}
		
		public function get playerDimension():Rectangle{
			if (this.player)
				return new Rectangle(player.x, player.y, player.width, player.height);
			else
				return new Rectangle(0, 0, 320, 240);
		}
		
		public function get isAutoPlay():Boolean{
			var configProxy:ConfigProxy = this.facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			var mediaProxy:MediaProxy = this.facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
			var ret:Boolean = false;
			if (configProxy && mediaProxy){
				ret = (configProxy.vo.flashvars.autoPlay == 'true' || mediaProxy.vo.singleAutoPlay) && !mediaProxy.vo.isMediaDisabled;
			}
			return ret;
		}
		
		public function get sequenceContext():String{
			return _sequenceProxy.sequenceContext;
		}
		
		private function get shouldWaitForMetadata():Boolean{
			var configProxy:ConfigProxy = this.facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			return configProxy && configProxy.vo.flashvars.requiredMetadataFields && !this.entryMetadata;
		}
		private function get shouldWaitForCuePoints():Boolean{
			var configProxy:ConfigProxy = this.facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			return  plugin.useKalturaTemporalSlots && configProxy && configProxy.vo.flashvars.getCuePointsData && !this.entryCuePoints;
		}
	}
}
