package com.kaltura.kdpfl.plugin.component {
	import com.kaltura.kdpfl.model.type.AdsNotificationTypes;
	
	import flash.display.Loader;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.LoaderContext;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import org.osmf.elements.beaconClasses.Beacon;
	import org.osmf.utils.HTTPLoader;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 * Mediator for the Overlay Plugin.
	 */
	public class OverlayMediator extends Mediator {
		
		/**
		 * mediator name 
		 */		
		public static var NAME:String = "overlayMediator";
		
		/**
		 * MovieClip holding the ad banner
		 */
		public var overlayMC:OverlayMC;


		/**
		 * if true, the banner should show as soon as it is ready.
		 */
		public var startRequired:Boolean = false;

		private var _overlayIsShowing:Boolean = false;
		private var _shownFirstOverlay:Boolean = false;
		private var firedStart:Boolean = false;
		private var _isReplay:Boolean = false;

		/**
		 *Timer designated to start the moment the banner is lowered.
		 */
		private var _overlayIntervalTimer:Timer;
		
		/**
		 * Timer designated to start the moment the banner is raised
		 */
		private var _showOverlayTimer:Timer;
		
		private var _shouldStartIntervalTimer : Boolean = true;

		

		/**
		 * Constructor. 
		 * @param newOverlayConfig	overlay configuration
		 * @param mediatorName		name of this mediator
		 * @param viewComponent		view component for thsi mediator
		 */
		public function OverlayMediator(viewComponent:Object = null) {
			super(NAME, viewComponent);
			overlayMC = (viewComponent as overlayPluginCode).overlayMC;
			overlayMC.buttonMode = true;
		}


		/**
		 * @inheritDoc
		 */
		override public function listNotificationInterests():Array {
			var notes:Array = ["mediaReady", "playerUpdatePlayhead", "changeMedia", "playerPlayEnd", "doPlay", "doPause", "showOverlayOnCuePoint" ];
			return notes;
		}


		/**
		 * @inheritDoc
		 */
		override public function handleNotification(notification:INotification):void {
			//if overlay is empty - return;
			//switch case
			var sequenceProxy:Proxy = facade.retrieveProxy("sequenceProxy") as Proxy;

			//If we are currently playing either pre-roll or post-roll sequences, there is no need for any overlay logic.
			if (sequenceProxy["vo"]["isInSequence"]) {
				overlayMC.lowerBanner();
				return;
			}

			switch (notification.getName()) {
				case "playerUpdatePlayhead":
					
					var currentTime:Number = Number(notification.getBody());
					if ((viewComponent as overlayPluginCode).currentOverlayConfig  ) {
						if (!_overlayIsShowing) {
							if (currentTime >= (viewComponent as overlayPluginCode).overlayStartAt && !_shownFirstOverlay) {
								_shownFirstOverlay = true;
								raiseBanner(null);
								_shouldStartIntervalTimer = true;
							}
						}
					}
					
					break;

				case "changeMedia":
					_shownFirstOverlay = false;
					resetOverlay();

					break;

				case "playerPlayEnd":
					resetOverlay();
					_isReplay = true;
					break;

				case "doPlay":
					if (sequenceProxy["vo"]["isInSequence"])
						return;
					if (!firedStart && (viewComponent as overlayPluginCode).currentOverlayConfig) {
						firedStart = true;
						fireTrackingEvent("start");
					}
					else {
						if (!(viewComponent as overlayPluginCode).currentOverlayConfig) {
							// Signifes that the "start" tracking event should have been fired, 
							// but the VAST document hasn't loaded yet
							startRequired = true;
						}
						if (_isReplay) {
							fireTrackingEvent("replay");
							_isReplay = false;
							startOverlayIntervalTimer();
						}
						else {
							if (_overlayIsShowing && _showOverlayTimer) {
								_showOverlayTimer.start();
							}
							else if (!_overlayIsShowing && _overlayIntervalTimer) {
								_overlayIntervalTimer.start();
							}
						}
					}
					break;

				case "doPause":
					if (_overlayIntervalTimer && _overlayIntervalTimer.running) {
						_overlayIntervalTimer.stop();
					}
					else if (_showOverlayTimer && _showOverlayTimer.running) {
						_showOverlayTimer.stop();
					}
					break;
				
				case "showOverlayOnCuePoint":

					raiseBanner(null);
					_shouldStartIntervalTimer = false;
					
					
					break;
			}

		}

		/**
		 * fire the tracking "start" event if needed. 
		 */
		public function fireStartEvent():void {
			if (startRequired) {
				fireTrackingEvent("start");
				startRequired = false;
			}
		}


		/**
		 * positions the banner according to player size
		 * @param width		player width
		 * @param height	player height
		 */
		public function updateBannerLocation(width:Number, height:Number):void {
			overlayMC.y = height;
			overlayMC.x = width / 2 - overlayMC.width / 2;

		}


		/**
		 * fires a tracking event to the url saved in the config object 
		 * @param eventType		type of event to fire.
		 */		
		public function fireTrackingEvent(eventType:String):void {
			if ((viewComponent as overlayPluginCode).currentOverlayConfig && (viewComponent as overlayPluginCode).currentOverlayConfig.trackingEvents[eventType]) {
				for (var i:int = 0; i < (viewComponent as overlayPluginCode).currentOverlayConfig.trackingEvents[eventType].length; i++) {
					var beacon:Beacon = new Beacon((viewComponent as overlayPluginCode).currentOverlayConfig.trackingEvents[eventType][i], new HTTPLoader());
					beacon.ping();
				}
			}
		}


		//Private functions

		/**
		 * Function loads the banner source (image/jpeg/swf) into the designated Sprite
		 * @param bannerUrl
		 *
		 */
		private function loadBanner(bannerUrl:String):void {
			var loader:Loader = new Loader();
			var urlReq:URLRequest = new URLRequest(bannerUrl);
			var loaderContext:LoaderContext = new LoaderContext(true);
			if (overlayMC.numChildren != 0) {
				for (var i:int = 0; i < overlayMC.numChildren; i++) {

					overlayMC.removeChildAt(i);
				}
				if (overlayMC.numChildren != 0)
					overlayMC.removeChildAt(0);
			}

			overlayMC.addChild(loader);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, bannerLoaded);
			loader.load(urlReq, loaderContext);
		}


		/**
		 * Function is activated when the banner source has loaded.
		 * Re-positions the banner sprite on the screen so that it is in the middle and adds X-Button
		 * @param e
		 *
		 */
		private function bannerLoaded(e:Event):void {
			if (e.type == Event.COMPLETE) {
				_overlayIsShowing = true;
				createClickThrough();
				fireTrackingEvent("creativeView");
				sendNotification(AdsNotificationTypes.AD_START, {timeSlot: "overlay"});
				updateBannerLocation(overlayMC.parent.width, overlayMC.parent.height);
				var cls:* = getDefinitionByName("BannerXButton") as Class;
				var xButton:SimpleButton = new cls as SimpleButton;
				xButton.addEventListener(MouseEvent.CLICK, onXClick);
				overlayMC.addXButton(xButton);
				overlayMC.raiseBanner();
			}
		}


		/**
		 * Function creates a click event listener for the banner.
		 *
		 */
		private function createClickThrough():void {
			overlayMC.getChildAt(0).addEventListener(MouseEvent.CLICK, onBannerClick);
		}


		/**
		 * Event listener for click on the banner image (navigates to the click-thru url)
		 * @param e
		 *
		 */
		private function onBannerClick(e:MouseEvent):void {
			var urlReq:URLRequest = new URLRequest((viewComponent as overlayPluginCode).currentOverlayConfig["nonLinearClickThrough"]);
			navigateToURL(urlReq);
			fireTrackingEvent("acceptInvitation");
			sendNotification(AdsNotificationTypes.AD_CLICK, {timeSlot: "overlay"});
		}


		/**
		 *Function starts counting the time when the banner is lowered until the banner is raised again.
		 *
		 */
		private function startOverlayIntervalTimer():void {
			if (!_overlayIntervalTimer) {
				_overlayIntervalTimer = new Timer((viewComponent as overlayPluginCode).overlayInterval * 1000, 1);
			}
			_overlayIntervalTimer.addEventListener(TimerEvent.TIMER_COMPLETE, raiseBanner);
			_overlayIntervalTimer.start();
		}


		/**
		 * Function starts the timer which counts the duration the banner is displayed (between the banner being raised and being lowered)
		 *
		 */
		private function startOverlayDurationTimer():void {
			if (!_showOverlayTimer) {
				_showOverlayTimer = new Timer((viewComponent as overlayPluginCode).displayDuration * 1000, 1);
			}
			_showOverlayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, lowerBanner);
			_showOverlayTimer.start();
		}


		/**
		 * When the timer counting the interval between overlays reaches its complete time, this function
		 * raises the banner to be visible and starts the timer which counts the duration of the banner being shown.
		 * @param e
		 *
		 */
		private function raiseBanner(e:TimerEvent = null):void {
			if ( !(viewComponent as overlayPluginCode).currentOverlayConfig || !(viewComponent as overlayPluginCode).currentOverlayConfig["nonLinearResource"] )
			{
				return;
			}
			loadBanner((viewComponent as overlayPluginCode).currentOverlayConfig["nonLinearResource"]);
			_overlayIsShowing = true;
			if (_overlayIntervalTimer && _overlayIntervalTimer.hasEventListener(TimerEvent.TIMER_COMPLETE)) {
				_overlayIntervalTimer.stop();
				_overlayIntervalTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, raiseBanner);
			}
			startOverlayDurationTimer();
		}


		/**
		 * When the timer counting the duration of the banner being displayed reaches its complete time, this function
		 * lowers the banner so that it is no longer visible and starts the timer which counts the duration of the interval between
		 * the banners being shown.
		 * @param e
		 *
		 */
		private function lowerBanner(e:TimerEvent = null):void {
			overlayMC.lowerBanner();
			_overlayIsShowing = false;
			if (_showOverlayTimer && _showOverlayTimer.hasEventListener(TimerEvent.TIMER_COMPLETE)) {
				_showOverlayTimer.stop();
				_showOverlayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, lowerBanner);
			}
			if (_shouldStartIntervalTimer)
			{
				startOverlayIntervalTimer();
			}
			sendNotification(AdsNotificationTypes.AD_END, {timeSlot: "overlay"});
			_shouldStartIntervalTimer = true;
		}


		/**
		 *Function forcibly stops the timer that counts the interval time between two banners being shown.
		 *
		 */
		private function stopIntervalTimer():void {
			if (_overlayIntervalTimer && _overlayIntervalTimer.hasEventListener(TimerEvent.TIMER_COMPLETE)) {
				_overlayIntervalTimer.stop();
				_overlayIntervalTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, raiseBanner);
			}
		}


		/**
		 * Function forcibly stops the timer counting the duration of the banner being displayed.
		 *
		 */
		private function stopDurationTimer():void {
			if (_showOverlayTimer && _showOverlayTimer.hasEventListener(TimerEvent.TIMER_COMPLETE)) {
				_showOverlayTimer.stop();
				_showOverlayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, lowerBanner);
			}
		}


		/**
		 * The function stops both the timers and lowers the banner
		 * (activated by the end of the entry)
		 *
		 */
		private function resetOverlay():void {
			if (_overlayIsShowing) {
				lowerBanner();
			}
			stopIntervalTimer();
			stopDurationTimer();

		}


		/**
		 * Event listener for clicking on x button.
		 * @param e
		 *
		 */
		private function onXClick(e:MouseEvent):void {
			this.lowerBanner();
		}

	}
}