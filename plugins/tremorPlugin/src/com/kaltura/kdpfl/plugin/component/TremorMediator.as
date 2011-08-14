package com.kaltura.kdpfl.plugin.component {
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.type.AdsNotificationTypes;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.SequenceContextType;
	import com.kaltura.puremvc.as3.patterns.mediator.SequenceMultiMediator;
	import com.tremormedia.acudeo.IAdManager;
	import com.tremormedia.acudeo.content.Content;
	import com.tremormedia.acudeo.events.AcudeoEvent;
	import com.tremormedia.acudeo.events.AdEvent;
	import com.tremormedia.acudeo.events.ControlsEvent;
	import com.tremormedia.acudeo.page.Page;
	import com.tremormedia.acudeo.player.Player;
	
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.interfaces.IProxy;

		public class TremorMediator extends SequenceMultiMediator {
		public static const NAME:String = "TremorMediator";
		
		// DO NOT change the following consts values, they match the ones in statistics plugin
		public static const PRE:String = "preroll";
		public static const MID:String = "midroll";
		public static const POST:String = "postroll";
		public static const FETCH_PARAMS:String = "fetchParams";
		
		public var params:Object;
		public var dispatcher:EventDispatcher = new EventDispatcher();

		// internal companion ad
		private var _clickUrl:String;
		private var _loader:Loader;
		public var hideInternalCompanion:Boolean;
		public var internalCompanionX:Number;
		public var internalCompanionY:Number;
		
		/**
		 * Tremor program id
		 */
		public var progId:String = "";

		/**
		 * Tremor Log level. <br/>
		 * optional values: ALL, DEBUG, INFO, WARN, ERROR and FATAL
		 */
		public var traces:String = "";

		/**
		 * current ad context. 
		 * possible values are preroll / midroll / postroll. 
		 */
		private var _adContext:String = TremorMediator.MID;

		/**
		 * Tremor's hell-ish ad manager 
		 */		
		private var _adManager:IAdManager;
		
		/**
		 * title of current media entry 
		 */		
		private var _entryTitle:String = "";
		
		/**
		 * id of current media entry 
		 */		
		private var _entryId:String = "";
		
		/**
		 * url of current media entry 
		 */		
		private var _entryUrl:String = "";
		
		/**
		 * current player volium 
		 */		
		private var _currentVolume:Number = 100;
		
		/**
		 * indicates the video had started playing and asked for prerolls
		 */		
		private var _requestAd:Boolean;
		
		/**
		 * indicates ads program is loaded 
		 */		
		private var _programLoaded:Boolean = false;
		
		/**
		 * init manager once only. 
		 */		
		private var _managerInit:Boolean = false;
		
		/**
		 * since the new enableGui mechanism in KDP counts calls to 
		 * enable/disable gui, use this to not call too many of any of them. 
		 */
		private var _controlsEnabled:Boolean = true;

		/**
		 * tremor send startAd for midrolls twice. we'll only dispatch one of them.
		 * hopefully. 
		 */
		private var _midrollStatFlag:Boolean = false;
		
		
		/**
		 * This flag is to mark when a mid roll was played
		 */
		private var paused:Boolean = false;
		
		
		/**
		 * Holder for internal companion ads 
		 */
		private var companionHolder:UIComponent;
			
		
		/**
		 * Constructor.
		 * @param viewComponent
		 * @param prog	Tremor program id
		 * @param tracesVolume	
		 * 
		 */
		public function TremorMediator(viewComponent:Object = null, prog:String = "", tracesVolume:String = "FATAL",companionHolder:UIComponent=null) {
			super(viewComponent);
			if (prog != "")
				progId = prog;
			traces = tracesVolume;
			this.companionHolder = companionHolder;
			_adManager = (viewComponent as Tremor).ad_manager;
		}

		
		/**
		 * initialize the ad manager 
		 */
		private function initAdManager():void {

			var player:Player = new Player();
			player.videoRegion = new Rectangle(0, 0, 300, 300);
			player.volume = 100;

			var page:Page = new Page();
			var flashvars:Object = facade.retrieveProxy("configProxy");
			page.url = flashvars.vo.flashvars.referer;

			_adManager.init({player: player, page: page, debug:"FATAL"});

			_adManager.setVolume(100);
			
			_adManager.addEventListener(AcudeoEvent.PROGRAM_LOADED, onAdManagerProgramLoaded);
			_adManager.addEventListener(AdEvent.DISPLAY_BANNERS, onDisplayBanners);
			_adManager.addEventListener(AcudeoEvent.START_CONTENT, onStartContent);
			_adManager.addEventListener(AcudeoEvent.PAUSE_CONTENT, onPauseContent);
			_adManager.addEventListener(AcudeoEvent.RESUME_CONTENT, onResumeContent);
			_adManager.addEventListener(ControlsEvent.STATE_CHANGED, onControlsStateChange);
			_adManager.addEventListener(AcudeoEvent.ADS_COMPLETE, onAdsComplete);
			_adManager.addEventListener(AcudeoEvent.ERROR, onAdsError);
			
			_adManager.addEventListener(AdEvent.END, onAdsEvent);
			_adManager.addEventListener(AdEvent.OVERLAYCLICK, onAdsEvent);
			_adManager.addEventListener(AdEvent.OVERLAYSHOWN, onAdsEvent);
			_adManager.addEventListener(AdEvent.VIDEOSTART, onAdsEvent);
			_adManager.addEventListener(AdEvent.CLICK, onAdsEvent);
			
			_adManager.addEventListener(AdEvent.HIDE_BANNERS, onHideBanner);

			_adManager.load({
				progId: progId
			});
			_managerInit = true;
		}
		/**
		 * API for JS to hide the companion banners
		 */
		public function onHideBanner(event:Object):void {
			try
			{
				if (ExternalInterface.available)
					ExternalInterface.call("hideCompanionBanners");
			} catch (e:Error)
			{
				trace("ExternalInterface error");
			}
		}
		
		private function onAdsEvent(event:AdEvent):void {
			switch (event.type) {
				case AdEvent.OVERLAYSHOWN:
					sendNotification(AdsNotificationTypes.AD_START, {timeSlot:"overlay"});
					break;
				case AdEvent.OVERLAYCLICK:
					sendNotification(AdsNotificationTypes.AD_CLICK, {timeSlot:"overlay"});
					break;
				case AdEvent.CLICK:
					sendNotification(AdsNotificationTypes.AD_CLICK, {timeSlot:_adContext});
					break;
				case AdEvent.VIDEOSTART:
					if (_adContext != TremorMediator.MID) {
						sendNotification(AdsNotificationTypes.AD_START, {timeSlot:_adContext});
					}
					else if (!_midrollStatFlag) {
						// now we know this is midroll start
						sendNotification(AdsNotificationTypes.AD_START, {timeSlot:_adContext});
						_midrollStatFlag = true;
					}
					else {
						// if it's possible to have 2 midrolls, this'll take care of sending correct stats for both. I think.
						_midrollStatFlag = false;
					}
					break;
				case AdEvent.END:
					
					trace(">>>>>>>>>>>>>>>   AdEvent.END  d");
					
					view.dispatchEvent(new Event("hideBackground"));
					enableControls();
					sendNotification(AdsNotificationTypes.AD_END, {timeSlot:_adContext});
					if(_loader && hideInternalCompanion)
					{
						try{
							_loader.parent.removeChild(_loader)
							_loader.unload();
							_loader = null;
						}catch(e:Error)
						{
							trace("failed to unload internal companion ad");
						}
					}
					break;
			}
		}
		
		
		
		/**
		 * assumably this is caused by adManager load timeout (Tremor left a default value
		 * of 4 seconds, which is hardly ever enough). <br/>
		 * however, the error event doesn't hold any information of the error type.. <br/>
		 * in this case, we end ads process. 
		 * @param evt
		 */		
		private function onAdsError(evt:Event):void {
			enableControls();
			//sendNotification(NotificationType.SEQUENCE_ITEM_PLAY_END);
		}
		

		private function onAdManagerProgramLoaded(evt:Event):void {
			_programLoaded = true; //race condition
			_adManager.removeEventListener(AcudeoEvent.PROGRAM_LOADED, onAdManagerProgramLoaded);
			if (_requestAd) {
				preAds();
				_requestAd = false;
			}
			else {
				_adManager.openSlate();
				enableControls();
				
			}
		}


		private function onControlsStateChange(evt:Object):void {
			if (evt.enabled) {
				enableControls();
			} else {
				disableControls();
			}
		}


		private function enableControls():void {
			if (!_controlsEnabled) {
				facade.sendNotification("enableGui", {guiEnabled: true, enableType: "full"});
				_controlsEnabled = true;
			}
		}


		private function disableControls():void {
			if (_controlsEnabled) {
				facade.sendNotification("enableGui", {guiEnabled: false, enableType: "full"});
				_controlsEnabled = false;
			}
		}


		private function onAdVideoProgress(evt:Event):void 
		{
			
		}


		/**
		 * display a companion ad (any ad)
		 * @param event
		 * */
		private function onDisplayBanners(event:Object):void {
			// external companion ads 
			try 
			{
				if (ExternalInterface.available)
					ExternalInterface.call("displayCompanionBanners", event.ad.banners,
										   {playerIndex: event.data.player.playerIndex});
			} catch (e:Error)
			{
				trace("ExternalInterface error");
			}
			//internal companion ads
			
			if(!event.ad.banners[0].imageUrl)
			{
				return;
			}
			if(!companionHolder)
			{
				
				return;
			}
			
			var bannerHolder_mc:MovieClip = new MovieClip();
			bannerHolder_mc.x=internalCompanionX;
			bannerHolder_mc.y=internalCompanionY;
			_loader = new Loader();
			bannerHolder_mc.buttonMode = true;
			var request:URLRequest = new URLRequest(event.ad.banners[0].imageUrl);
			_loader.load(request);
			//Add click-through event listener.
			_clickUrl = event.ad.banners[0].clickUrl.toString();
			bannerHolder_mc.addEventListener(MouseEvent.CLICK,  onBannerHolderClick);
			bannerHolder_mc.addChild(_loader);
			companionHolder.addChild(bannerHolder_mc);
			
		}
		
		private function onBannerHolderClick(event:Object):void {
			var request:URLRequest = new URLRequest(_clickUrl);
			navigateToURL(request,"_blank");
		}


		/**
		 * for prerolls and postrolls, we need to trigger ads manually.
		 */
		public function forceStart():void {
			var sequenceManager:IProxy = facade.retrieveProxy("sequenceProxy");
			if (sequenceManager["sequenceContext"] == SequenceContextType.PRE) {
				sendNotification(preSequenceNotificationStartName);
			} else if (sequenceManager["sequenceContext"] == SequenceContextType.POST) {
				sendNotification(postSequenceNotificationStartName);
			}
		}


		/**
		 * Initialization of the tremor component. This is done here (and not previously), since only here we
		 * know that all config values are present
		 */
		override public function onRegister():void {
		}


		override public function listNotificationInterests():Array {
			var notify:Array = [preSequenceNotificationStartName,
								postSequenceNotificationStartName,
								NotificationType.PLAYER_UPDATE_PLAYHEAD,
								NotificationType.VOLUME_CHANGED,
								NotificationType.LAYOUT_READY,
								NotificationType.CHANGE_MEDIA_PROCESS_STARTED
			];
			return notify;
		}


		override public function handleNotification(note:INotification):void {
			var kc:Object = facade.retrieveProxy("servicesProxy")["kalturaClient"];
			var config:Object = facade.retrieveProxy("configProxy");
			var media:Object = facade.retrieveProxy("mediaProxy");
			var sequenceProxy:Object = facade.retrieveProxy("sequenceProxy");
			var data:Object = note.getBody();
			switch (note.getName()) {
				case NotificationType.PLAYER_UPDATE_PLAYHEAD:
					if (media["vo"]["entry"]["duration"] && !sequenceProxy["vo"]["isInSequence"]) {
						setPlayhead(data as Number, media["vo"]["entry"]["duration"]);
					}
					break;
				case NotificationType.VOLUME_CHANGED:
					setVolume(data.newVolume);
					break;

				case preSequenceNotificationStartName:
					var newEntryId:String = (facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.entry.id;
					preAds(newEntryId);
					break;

				case postSequenceNotificationStartName:
					postAds();
					clearMediaData();
					break;
				
				case NotificationType.LAYOUT_READY:
					if (!_managerInit) {
						initAdManager();
					}
					break;
			}
		}


		/**
		 * delete all data concerning the current entry, so when
		 * the next entry loads we'll ask for new info 
		 */
		private function clearMediaData():void {
			_entryTitle = null;
			_entryId = null;
			_entryUrl = null;
		}
		
		
		private function retrieveMediaData():void {
			var mp:Object = facade.retrieveProxy("mediaProxy");
			_entryTitle = mp.vo.entry.name;
			_entryId = mp.vo.entry.id;
			_entryUrl = mp.vo.entry["dataUrl"];
			var content:Content = new Content();
			dispatcher.dispatchEvent(new Event(FETCH_PARAMS));
			if(params)
				content.adParams = params;
			content.id = _entryId;
			content.url = _entryUrl;
			content.title = _entryTitle
			_adManager.setContent(content);
		}


		/**
		 * show preroll ads
		 */
		private function preAds(newEntryId : String=""):void {
			disableControls();
			_adContext = TremorMediator.PRE;
			//check if the ad manager is ready - race condition
			if (_programLoaded) {
				if (!_entryId || _entryId != newEntryId) {
					retrieveMediaData();
				}
				_adManager.contentPreStart();
			} else {
				// program not yet loaded - we need to wait for it.
				_requestAd = true;
			}
		}


		/**
		 * show postroll ads
		 */
		private function postAds():void {
			_adContext = TremorMediator.POST;
			_adManager.contentEnd();
		}


		/////////////////////////////////////////////////////////
		// TREMOR FUNCTIONS API 
		/////////////////////////////////////////////////////////

		/**
		 * after playing the pre-roll - this function tells the player to resume playing
		 * the original video if no pre-roll it will be called automaticaly
		 * @param event
		 */
		private function onStartContent(event:Object):void {
			/* switch the context to MID. if there's no midroll and the next ad 
			* will be a postroll, postAds() will change the context to match. */
			_adContext = TremorMediator.MID;
			enableControls();
			sendNotification(NotificationType.SEQUENCE_ITEM_PLAY_END);
		}


		/**
		 * whenever a tremor component shows mid roll ad (or a a banner clicked and opened a video ad) - pause the current video
		 * @param event
		 */
		private function onPauseContent(event:Object):void {
			paused = true;
			sendNotification("doPause");
		}


		/**
		 * whenever a tremor component finished showing a mid video ad - resume the current video
		 * @param event
		 */
		private function onResumeContent(event:Object):void {
			paused = false;
			sendNotification(NotificationType.DO_PLAY);
		}


		/**
		 * Call when everything is done - including post rolls
		 * @param event
		 */
		public function onAdsComplete(event:Object):void {
			enableControls();
			sendNotification(NotificationType.SEQUENCE_ITEM_PLAY_END);
		}



		//////////////////////////////////////////////////////////////////////////////////////
		//Player properties changed
		/////////////////////////////////////////////////////////////////////////////////////		
		/**
		 * Update the tremor component on playhead changes.
		 * @param currentPosition playhead current position
		 * @param duration the length of the movie
		 */
		private function setPlayhead(currentPosition:Number, duration:Number):void {
			// Call as content is playing
			if (_adManager && !paused) {
				_adManager.contentProgress(currentPosition, duration);

			}
		}


		/**
		 * Update the tremor component on screen size changes.
		 * @param w the new width
		 * @param h the new height
		 */
		public function setScreenSize(w:Number, h:Number):void {
			// Call when video player window changes size (example fullscreen)
			if (_adManager) {
				_adManager.setVideoRegion(new Rectangle(0, 0, w, h));
			}
		}


		/**
		 * Update the tremor component on volume changes.
		 * @param volume the new volume (0 to 1 scale)
		 */
		public function setVolume(volume:Number):void {
			_currentVolume = volume * 100;
			if (_adManager)
				_adManager.setVolume(_currentVolume);
		}


		public function get view():DisplayObject {
			return viewComponent as DisplayObject;
		}
	}
}