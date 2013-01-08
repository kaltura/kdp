package com.kaltura.kdfl.plugin.component {

	import com.eyewonder.instream.events.UIFControlEvent;
	import com.eyewonder.instream.events.UIFEvent;
	import com.eyewonder.instream.events.UIFTrackEvent;
	import com.eyewonder.instream.players.AdTypes;
	import com.kaltura.kdfl.plugin.type.EyewonderVideoState;
	import com.kaltura.puremvc.as3.patterns.mediator.SequenceMultiMediator;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;

	public class EyewonderMediator extends SequenceMultiMediator {

		/**
		 * This string can be a number that represent the time in seconds to start the overlay delay to show the overlay
		 * it can be a percentage that is calculated and set to _showOverlayInSec when the duration is known
		 */
		private var _showOverlayAt:String;
		
		/**
		 * 	This string can be a number that represent the time in seconds to show the Midroll
		 *  it can be a percentage that is calculated and set to _showMidrollInSec when the duration is known
		 */
		private var _showMidrollAt:String;
		
		/**
		 * showOverlayAt setter is translating the string to the point in time when an Overlay should be shown,
		 * the number in seconds defined by _showOverlayInSec
		 */
		private var _showOverlayInSec:int;
		
		/**
		 * showMidrollAt setter is translating the string to the point in time when an Midroll should be shown
		 * the number in seconds defined by _showOverlayInSec
		 */
		private var _showMidrollInSec:int;
		
		/**
		 * The pause was called twice with no resone so we need to now what is the video state to not
		 * call it again after the first pause
		 */
		private var _videoState:int = EyewonderVideoState.NONE;
		
		/**
		 * the current (active) time slot. <br/>
		 * possible values are <code>preroll/postroll/midroll/overlay</code>.
		 */
		private var _currentRoll:String;
		
		/**
		 * a flag to tell the framework to show reminder ads after preroll 
		 */
		private var _shouldShowBug:Boolean;



		/**
		 * Constructor
		 * @param viewComponent
		 *
		 */
		public function EyewonderMediator(viewComponent:Object = null) {
			super(viewComponent);
			eyewonder.addEventListener(Eyewonder.AD_MANAGER_READY, onAdManagerReady);
		}


		/**
		 * setter that calculat and extract the _showOverlayInSec accordintg to _showOverlayAt
		 * @param value is the time in string, can be percentage (for example "50%") or just a certain second in time
		 *
		 */
		public function set showOverlayAt(value:String):void {
			_showOverlayAt = value;
			_showOverlayInSec = extractTime(value);
		}


		/**
		 * setter that calculat and extract the _showMidrollInSec accordintg to _showMidrollAt
		 * @param value is the time in string, can be percentage (for example "50%") or just a certain second in time
		 *
		 */
		public function set showMidrollAt(value:String):void {
			_showMidrollAt = value;
			_showMidrollInSec = extractTime(value);
		}


		/**
		 * checks if the time is defind or need to be extracted from percentage according to the media duration
		 * @param value is the time in string, can be percentage (for example "50%") or just a certain second in time
		 * @return the time in second reltive to the media duration
		 */
		private function extractTime(value:String):Number {
			var timeToShow:Number;
			//if this is percentage
			if (String(value).split("%").length == 2) {
				var perNum:Number = String(value).split("%")[0];
				var per:Number = perNum / 100;
				var mediaProxy:Object = facade.retrieveProxy("mediaProxy");
				if (mediaProxy["vo"].entry.hasOwnProperty('duration')) {
					timeToShow = per * mediaProxy["vo"].entry.duration;
				}
			}
			else
				timeToShow = Number(value);

			return timeToShow;
		}


		/**
		 * sets the size of the plugin. 
		 * @param w		new width
		 * @param h		new height
		 */		
		public function setSize(w:Number, h:Number):void {
			eyewonder.adManager.config.width = w;
			eyewonder.adManager.config.height = h;

			if (eyewonder && eyewonder.adManager)
				eyewonder.adManager.resize(w, h, 0, 0);
		}


		/**
		 * Pure MVC way to listen to KDP 3 notifications
		 * @return	 the list of notifications this plugins listens to
		 */
		override public function listNotificationInterests():Array {
			var notify:Array = new Array("playerUpdatePlayhead", "mediaReady", "durationChange", "changeMedia", "playerPlayEnd", "playerPlayed", preSequenceNotificationStartName, postSequenceNotificationStartName);
			return notify;
		}


		/**
		 * Pure MVC way to handle KDP 3 notifications
		 * @param note 	notification
		 */
		override public function handleNotification(note:INotification):void {
			var config:Object = facade.retrieveProxy("configProxy");
			var media:Object = facade.retrieveProxy("mediaProxy");
			var data:Object = note.getBody();

			///TEST!!!!!!!!!1
			//eyewonder.width = 720;
			//eyewonder.height = 360;
			/////////////////////////////////////////

			switch (note.getName()) {
				case "changeMedia":
					//on change media reset the ads flags
					eyewonder.adManager.reset();
					break;
				case "durationChange":
					showOverlayAt = _showOverlayAt;
					showMidrollAt = _showMidrollAt;
					break;
				case "playerUpdatePlayhead":

					//check if we need to show overlay
					if (eyewonder.adManager.config.overlay
						&& Math.round(Number(data)) >= _showOverlayInSec 
						&& !eyewonder.adManager.adPlayed[AdTypes.OVERLAY]) {
						_currentRoll = "overlay";
						eyewonder.adManager.startAd(AdTypes.OVERLAY);
					}

					if (!eyewonder.adManager.adPlayed[AdTypes.MIDROLL]) {
						//check if we need to show midroll
						if (Math.round(Number(data)) == _showMidrollInSec && eyewonder.adManager.config.midroll) {
							_currentRoll = "midroll";
							eyewonder.adManager.startAd(AdTypes.MIDROLL);
						}
					}
					break;
				case "playerPlayEnd":

					break;
				case "playerPlayed":
					break;
				case preSequenceNotificationStartName:
					if (!eyewonder.adManager.adPlaying && eyewonder.adManager.config.preroll) {
						// if we have reached even once to the end of the entry don't display 
						// the ads any more
						if (eyewonder.adManager.adPlayed[AdTypes.PREROLL]) {
							facade.sendNotification("sequenceItemPlayEnd");
							return;
						}

						_currentRoll = "preroll";
						eyewonder.adManager.startAd(AdTypes.PREROLL);
						sendNotification("enableGui", {guiEnabled: false, enableType: "full"});

					}
					else
						preEnd();
					break;
				case postSequenceNotificationStartName:
					if (!eyewonder.adManager.adPlaying && eyewonder.adManager.config.postroll) {
						//if we have reached even once to the end of the entry don't display the ads any more
						if (eyewonder.adManager.adPlayed[AdTypes.POSTROLL]) {
							facade.sendNotification("sequenceItemPlayEnd");
							return;
						}
						_currentRoll = "postroll";
						eyewonder.adManager.startAd(AdTypes.POSTROLL);
						sendNotification("enableGui", {guiEnabled: false, enableType: "full"});
					}
					else
						postEnd();
					break;
			}
		}


		/**
		 * When the preroll ad done playing preEnd() is executed
		 */
		private function preEnd():void {
			facade.sendNotification("sequenceItemPlayEnd");
			sendNotification("enableGui", {guiEnabled: true, enableType: "full"});
		}


		/**
		 * When the postroll ad done playing postEnd() is executed
		 */
		private function postEnd():void {
			facade.sendNotification("sequenceItemPlayEnd");
			sendNotification("enableGui", {guiEnabled: true, enableType: "full"});
		}


		/**
		 * When the manager is ready we can start register to its events
		 * @param event
		 *
		 */
		private function onAdManagerReady(event:Event):void {
			eyewonder.adManager.addEventListener(UIFEvent.CONTROL_EVENT, controlEventHandler);
			eyewonder.adManager.addEventListener(UIFEvent.TRACK_EVENT, trackEventHandler);
		}


		/**
		 * the adManager dispatches tracking events (statistics) that this Mediator handles here.
		 * @param evt
		 */
		private function trackEventHandler(evt:UIFEvent):void {
			switch (evt.info.type) {
				case UIFTrackEvent.TRACK_START_OF_VIDEO:
					sendNotification("adStart", {timeSlot: _currentRoll});
					break;

				case UIFTrackEvent.TRACK_FIRST_QUARTILE_OF_VIDEO:
					sendNotification("firstQuartileOfAd", {timeSlot: _currentRoll});
					break;

				case UIFTrackEvent.TRACK_MID_OF_VIDEO:
					sendNotification("midOfAd", {timeSlot: _currentRoll});
					break;

				case UIFTrackEvent.TRACK_THIRD_QUARTILE_OF_VIDEO:
					sendNotification("ThirdQuartileOfAd", {timeSlot: _currentRoll});
					break;

				case UIFTrackEvent.TRACK_END_OF_VIDEO:
					sendNotification("adEnd", {timeSlot: _currentRoll});
					break;

				case UIFTrackEvent.TRACK_CLICKTHRU:
					sendNotification("adClick", {timeSlot: _currentRoll});
					break;
			}
		}


		/**
		 * the adManager dispatch control events that this Mediator hanlde here
		 * @param evt
		 */
		private function controlEventHandler(evt:UIFEvent):void {
			switch (evt.info.type) {
				case UIFControlEvent.ON_END_AD:
					_videoState = EyewonderVideoState.NONE;

					if (eyewonder.adManager.adType == AdTypes.PREROLL) {
						preEnd();
						if (_shouldShowBug) {
							eyewonder.adManager.startAd(AdTypes.OVERLAY);
							_shouldShowBug = false;
						}
					}
					else if (eyewonder.adManager.adType == AdTypes.POSTROLL) {
						postEnd();
					}

					break;
				case UIFControlEvent.CONTENT_VID_PLAY:
					if (eyewonder.adManager.adType != AdTypes.POSTROLL && eyewonder.adManager.adType != AdTypes.PREROLL) {
						facade.sendNotification("doPlay");
						sendNotification("enableGui", {guiEnabled: true, enableType: "full"});
						_videoState = EyewonderVideoState.PLAY;
					}
					break;
				case UIFControlEvent.CONTENT_VID_PAUSE:
					if (eyewonder.adManager.adType != AdTypes.POSTROLL && eyewonder.adManager.adType != AdTypes.PREROLL && _videoState != EyewonderVideoState.PAUSE) //3 == Pause
					{
						facade.sendNotification("doPause");
						sendNotification("enableGui", {guiEnabled: false, enableType: "full"});
						_videoState = EyewonderVideoState.PAUSE;
					}
					break;
				case UIFControlEvent.CONTENT_VID_STOP:
					_videoState = EyewonderVideoState.STOP;
					// Note: This case may will be used with future releases. If so...
					// TODO: Add code to tell the player to stop the publisher's video					
					//facade.sendNotification("doStop");	
					break;
				case UIFControlEvent.ON_REMINDER_DETECTED:
					_shouldShowBug = true;
					break;
				case UIFControlEvent.AD_REMAINING_TIME:

					break;
				// TODO: Add other cases to catch the following events:
				/*
				 *	case UIFControlEvent.AD_INFORMATION_DATA
				 *	case UIFControlEvent.ON_AD_LOAD_COMPLETE
				 *	case UIFControlEvent.ON_START_PLAY_AD
				 *	case UIFControlEvent.ON_START_REQUEST_AD
				 *	case UIFControlEvent.ON_START_LINEAR
				 *	case UIFControlEvent.ON_START_LINEAR_INTERACTIVE
				 *	case UIFControlEvent.ON_START_OVERLAY
				 *	case UIFControlEvent.ON_REMINDER_OVERRIDE
				 *	case UIFControlEvent.ON_RESIZE_NOTIFY
				 */

				// TODO: Add those cases if the player does use a overlay-controller or something similar that is placed/added above the ad
				// recommended to use with Interactive Linear and Overlay Ticker-Ads
				/*
				 *  case UIFControlEvent.HIDE_CONTROLS
				 *  case UIFControlEvent.SHOW_CONTROLS
				 */
				// For more information look at the Instream Framework Specification
				default:
					//instreamFramework._debugMessage(2, "unhandled Control Event: " + evt.info.type );
					break;
			}
		}


		/**
		 * reference to the eyewonder view component that this Mediator wrap
		 * @return wrapped eyewonder
		 *
		 */
		public function get eyewonder():Eyewonder {
			return this.viewComponent as Eyewonder;
		}


		/**
		 *Function to start the plugin playback
		 *
		 */
		public function forceStart():void {
			var sequenceManager:Object = facade.retrieveProxy("sequenceProxy");
			if (sequenceManager.sequenceContext == "pre") {
				sendNotification(preSequenceNotificationStartName);
			}
			else if (sequenceManager.sequenceContext == "post") {
				sendNotification(postSequenceNotificationStartName);
			}
		}

	}
}