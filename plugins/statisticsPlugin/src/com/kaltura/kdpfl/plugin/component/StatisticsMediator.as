package com.kaltura.kdpfl.plugin.component {
	import com.kaltura.KalturaClient;
	import com.kaltura.commands.stats.StatsCollect;
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.AdsNotificationTypes;
	import com.kaltura.types.KalturaStatsEventType;
	import com.kaltura.vo.KalturaStatsEvent;
	
	import flash.display.DisplayObject;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * Class StatisticsPluginMediator is responsible for "catching" the KDP notifications and translating them to the appropriate statistics events.
	 * @author Hila
	 * 
	 */	
	public class StatisticsMediator extends Mediator {
		
		
		/**
		 * Mediator name 
		 */		
		public static const NAME:String = "statisticsMediator";
		
		
		public var statsDomain : String;
		
		private var _flashvars : Object;
		
		/**
		 * Parameter signifying whether statistics should be disabled. 
		 */		
		public var statsDis:Boolean;
		
		/**
		 * A flag that makes sure that only one "widgetLoaded event is fired per session. 
		 */		
		private var _ready:Boolean = false;
		
		/**
		 * Flag indicating that is a seek operation is on-going.
		 */		
		private var _inSeek:Boolean = false;
		
		/**
		 * iFlag indicating that the scrubber is being dragged.
		 */		
		private var _inDrag:Boolean = false;
		
		/**
		 * Flag indicating that fast forward operation is on-going. 
		 */		
		private var _inFF:Boolean = false;
		
		/**
		 * Flag indicating that the 25% point of the video has been reached.
		 */		
		private var _p25Once:Boolean = false;
		
		/**
		 *Flag indicating that the midway point of the video has been reached.
		 */	
		private var _p50Once:Boolean = false;
		
		/**
		 * Flag indicating that the 75% point of the video has been reached.
		 */	
		private var _p75Once:Boolean = false;
		
		/**
		 * Flag indicating that the video has completed playback.
		 */	
		private var _p100Once:Boolean = false;
		
		/**
		 *Flag that makes sure that the event "play" is dispatched only once per entry.
		 */		
		private var _played:Boolean = false;
		
		/**
		 * Flag indicating that a seek operation has been performed. 
		 */		
		private var _hasSeeked:Boolean = false;
		
		/**
		 * Flag indicating that the Player is in Full-Screen mode.
		 */		
		private var _fullScreen:Boolean = false;
		
		/**
		 * Flag indicating that the Player is normal-sized (not in Ful-Screen mode).
		 */		
		private var _normalScreen:Boolean = false;
		
		/**
		 * Parameter indicating the last position that as seek operation has been performed to.
		 */		
		private var _lastSeek:Number = 0;
		
		/**
		 * Parameter holds the Id of the last entry played by the KDP.
		 */		
		private var _lastId:String = "";
		
		/**
		 * Flag indicating whether the entry that was loaded is a new one, and not a change in the same entry's flavor and not
		 * the result if intelligent seeking.
		 */		
		private var _isNewLoad:Boolean = false;
		
		private var _kc : KalturaClient;
		
		/**
		 * Constructor 
		 * @param disStats - boolean signifying that the statistics should no be dispatched.
		 * @param viewComponent
		 * 
		 */		
		public function StatisticsMediator(disStats:Boolean, viewComponent:Object = null) {
			super(NAME, viewComponent);
			
			statsDis = disStats;
		}
		
		/**
		 * Function returns the array of KDP notifications that the Mediator listens for. 
		 * @return array of the notifications that interest the Mediator.
		 * 
		 */		
		override public function listNotificationInterests():Array {
			return [
				"hasOpenedFullScreen", 
				"hasCloseFullScreen", 
				"playerUpdatePlayhead",  
				"playerPlayed", 
				"mediaReady", 
				"playerSeekStart", 
				"playerSeekEnd", 
				"scrubberDragStart", 
				"scrubberDragEnd", 
				"playerPaused", 
				"playerPlayEnd", 
				"playerStateChange", 
				"changeMedia", 
				"kdpReady",
				"kdpEmpty",
				"gotoEditorWindow", 
				"doDownload", 
				"doGigya", 
				"doSeek", 
				"gotoContributorWindow", 
				AdsNotificationTypes.AD_START, 
				AdsNotificationTypes.AD_CLICK, 
				AdsNotificationTypes.BUMPER_STARTED, 
				AdsNotificationTypes.BUMPER_CLICKED,
				AdsNotificationTypes.FIRST_QUARTILE_OF_AD,
				AdsNotificationTypes.MID_OF_AD,
				AdsNotificationTypes.THIRD_QUARTILE_OF_AD
			];
		}
		
		override public function onRegister():void 
		{
			_flashvars = facade.retrieveProxy("configProxy")["vo"]["flashvars"];
			
			var config : KalturaConfig = new KalturaConfig();
			config.domain = statsDomain ? statsDomain : _flashvars.host;
			config.ks = facade.retrieveProxy("servicesProxy")["kalturaClient"]["ks"];
			config.partnerId = _flashvars.partnerId;
			config.protocol = _flashvars.httpProtocol;
			config.clientTag = facade.retrieveProxy("servicesProxy")["kalturaClient"]["clientTag"];
			_kc = new KalturaClient(config);
		}
		
		
		/**
		 * Function creates a statistics callback and initiates it with the basic data from the KDP.
		 * @param ks	session id 
		 * @return statistics event with basic (common) data
		 */
		private function getBasicStatsData(ks:String):KalturaStatsEvent {
			var config:Object = facade.retrieveProxy("configProxy");
			var mediaPlayer:Object = facade.retrieveMediator("kMediaPlayerMediator");
			var kse:KalturaStatsEvent = new KalturaStatsEvent();
			kse.partnerId = config["vo"]["flashvars"].partnerId;
			kse.widgetId = config["vo"]["flashvars"].id;
			kse.uiconfId = config["vo"].flashvars.uiConfId;
			// this is where we choose the entry to report on
			if ((facade.retrieveProxy("mediaProxy"))["vo"].entry.id)
				kse.entryId = (facade.retrieveProxy("mediaProxy"))["vo"].entry.id;
			kse.clientVer = "3.0:" + facade["kdpVersion"];
			var dt:Date = new Date();
			kse.eventTimestamp = dt.time + dt.timezoneOffset - dt.timezoneOffset * 60; // milisec UTC + users timezone offset
			if (mediaPlayer) {
				kse.duration = mediaPlayer["player"].duration;
				kse.currentPoint = Number(mediaPlayer["player"].currentTime) * 1000;
			}
			kse.sessionId = config["vo"]["sessionId"];
			kse.seek = _hasSeeked;
			kse.referrer = config["vo"].flashvars.referer;
			if (!kse.referrer)
				kse.referrer = config["vo"].flashvars.refferer;
			
			// verify the the referrer is escaped once
			kse.referrer = escape(unescape(kse.referrer));
			return kse;
		}
		
		/**
		 * Function checks whether a progress statistics event should be dispathced.
		 * @param currPosition	current playhead position
		 * @param duration		media duration
		 * @return 	event type code, or -1 if none matched
		 * 
		 */
		private function percentStatsChanged(currPosition:Number, duration:int):int {
			
			var percent:Number = 0;
			var seekPercent:Number = 0;
			
			if (_inDrag || _inFF) {
				return int.MIN_VALUE;
			}
			
			if (duration > 0) {
				percent = currPosition / duration;
				seekPercent = _lastSeek / duration;
			}
			
			if (!_p25Once && Math.round(percent * 100) >= 25 && seekPercent < 0.25) {
				_p25Once = true;
				return com.kaltura.types.KalturaStatsEventType.PLAY_REACHED_25;
			}
			else if (!_p50Once && Math.round(percent * 100) >= 50 && seekPercent < 0.50) {
				_p50Once = true;
				return com.kaltura.types.KalturaStatsEventType.PLAY_REACHED_50;
			}
			else if (!_p75Once && Math.round(percent * 100) >= 75 && seekPercent < 0.75) {
				_p75Once = true;
				return com.kaltura.types.KalturaStatsEventType.PLAY_REACHED_75;
			}
			else if (!_p100Once && Math.round(percent * 100) >= 98 && seekPercent < 1) {
				_p100Once = true;
				return com.kaltura.types.KalturaStatsEventType.PLAY_REACHED_100;
			}
			
			return int.MIN_VALUE;
		}
		
		/**
		 *  Function responsible for dispatching the appropriate statistics event according to the notification fired by the KDP.
		 * @param note notification fired by the KDP and caught by the Mediator.
		 * 
		 */		
		override public function handleNotification(note:INotification):void {
			
			if (statsDis)
				return;
			var timeSlot:String;
			//var _kc:KalturaClient = facade.retrieveProxy("servicesProxy")["kalturaClient"];		
			var kse:KalturaStatsEvent = getBasicStatsData(_kc.ks);
			var data:Object = note.getBody();
			
			var sequenceProxy : SequenceProxy = facade.retrieveProxy( SequenceProxy.NAME ) as SequenceProxy;
			
			if (sequenceProxy.vo.isInSequence)
			{
				handleAdsNotifications();
			}
			else
			{
				handleMainContentNotifications();
			}
			
			// if we enter this function for any wrong reason and we don't have event to send, just return...
			if (!kse.eventType || kse.eventType == int.MIN_VALUE) {
				return;
			}
			
			var collect:StatsCollect = new StatsCollect(kse);
			collect.method = URLRequestMethod.GET;
			_kc.post(collect);
			
			function handleMainContentNotifications () : void
			{
				switch (note.getName()) 
				{
					case "hasOpenedFullScreen":
						if (_fullScreen == false) {
							kse.eventType = com.kaltura.types.KalturaStatsEventType.OPEN_FULL_SCREEN;
						}
						_fullScreen = true;
						_normalScreen = false;
						break;
					case "hasCloseFullScreen":
						if (_normalScreen == false) {
							kse.eventType = com.kaltura.types.KalturaStatsEventType.CLOSE_FULL_SCREEN;
						}
						_fullScreen = false;
						_normalScreen = true;
						break;
					
					case "kdpEmpty":
						if (_ready)
							return;
						kse.eventType = com.kaltura.types.KalturaStatsEventType.WIDGET_LOADED;
						_ready = true;
						break;
					
					case "playerPlayed":
						
						
						//In the case of a bumper entry, the bumper has already reported PLAYER_PLAYED for the 
						//statistics "session" of the real entry, which causes wrong input of analytics.
						if (_lastId != kse.entryId) {
							_played = false;
							_lastId = kse.entryId;
						}
						
						if (_isNewLoad && !_played) {
							kse.eventType = com.kaltura.types.KalturaStatsEventType.PLAY;
							_played = true;
						}
						
						break;
					
					
					case "mediaReady":
						
						if (kse.entryId) {
							if (_lastId != kse.entryId) {
								_played = false;
								_lastId = kse.entryId;
								_hasSeeked = false;
								_p25Once = false;
								_p50Once = false;
								_p75Once = false;
								_p100Once = false;
								_isNewLoad = true;
								kse.eventType = com.kaltura.types.KalturaStatsEventType.MEDIA_LOADED;
							}
							else {
								_isNewLoad = false;
								_lastSeek = 0;
							}
						}
						break;
					
					case "playerSeekEnd":
						_inSeek = false;
						return;
						break;
					
					case "scrubberDragStart":
						_inDrag = true;
						return;
						break;
					
					case "scrubberDragEnd":
						_inDrag = false;
						_inSeek = false;
						return;
						break;
					
					case "playerUpdatePlayhead":
						
						kse.eventType = percentStatsChanged(data as Number, kse.duration);
						if (kse.eventType < 0) {
							return; // negative number means no need to change update
						}
						break;
					
					case "kdpReady":
						// Ready should not occur more than once
						if (_ready)
							return;
						kse.eventType = com.kaltura.types.KalturaStatsEventType.WIDGET_LOADED;
						_ready = true;
						break;
					case "gotoEditorWindow":
						kse.eventType = com.kaltura.types.KalturaStatsEventType.OPEN_EDIT;
						break
					case "doDownload":
						kse.eventType = com.kaltura.types.KalturaStatsEventType.OPEN_DOWNLOAD;
						break;
					case "doGigya":
						kse.eventType = com.kaltura.types.KalturaStatsEventType.OPEN_VIRAL;
						break;
					case "flagForReview":
						kse.eventType = com.kaltura.types.KalturaStatsEventType.OPEN_REPORT;
						break;
					case "doSeek":
						if (_inDrag && !_inSeek) {
							kse.eventType = com.kaltura.types.KalturaStatsEventType.SEEK;
						}
						_lastSeek = Number(note.getBody());
						_inSeek = true;
						_hasSeeked = true;
						break;
					case "gotoContributorWindow":
						kse.eventType = com.kaltura.types.KalturaStatsEventType.OPEN_UPLOAD;
						break;
				}
			}
			
			function handleAdsNotifications ()  : void
			{
				
				switch (note.getName())
				{
					case AdsNotificationTypes.BUMPER_CLICKED:
						kse.eventType = com.kaltura.types.KalturaStatsEventType.BUMPER_CLICKED;
						break;
					case AdsNotificationTypes.BUMPER_STARTED:
						if (note.getBody().timeSlot == "preroll") {
							kse.eventType = com.kaltura.types.KalturaStatsEventType.PRE_BUMPER_PLAYED;
						}
						else if (note.getBody().timeSlot == "postroll") {
							kse.eventType = com.kaltura.types.KalturaStatsEventType.POST_BUMPER_PLAYED;
						}
						break;
					case AdsNotificationTypes.AD_CLICK:
						timeSlot = note.getBody().timeSlot;
						switch (timeSlot) {
							case "preroll":
								kse.eventType = com.kaltura.types.KalturaStatsEventType.PREROLL_CLICKED;
								break;
							case "midroll":
								kse.eventType = com.kaltura.types.KalturaStatsEventType.MIDROLL_CLICKED;
								break;
							case "postroll":
								kse.eventType = com.kaltura.types.KalturaStatsEventType.POSTROLL_CLICKED;
								break;
							case "overlay":
								kse.eventType = com.kaltura.types.KalturaStatsEventType.OVERLAY_CLICKED;
								break;
							
						}
						break;
					case AdsNotificationTypes.AD_START:
						timeSlot = note.getBody().timeSlot;
						switch (timeSlot) {
							case "preroll":
								kse.eventType = com.kaltura.types.KalturaStatsEventType.PREROLL_STARTED;
								break;
							case "midroll":
								kse.eventType = com.kaltura.types.KalturaStatsEventType.MIDROLL_STARTED;
								break;
							case "postroll":
								kse.eventType = com.kaltura.types.KalturaStatsEventType.POSTROLL_STARTED;
								break;
							case "overlay":
								kse.eventType = com.kaltura.types.KalturaStatsEventType.OVERLAY_STARTED;
								break;
						}
						break;
					case AdsNotificationTypes.FIRST_QUARTILE_OF_AD:
						timeSlot = note.getBody().timeSlot;
						switch (timeSlot) {
							case "preroll":
								kse.eventType = com.kaltura.types.KalturaStatsEventType.PREROLL_25;
								break;
							case "midroll":
								kse.eventType = com.kaltura.types.KalturaStatsEventType.MIDROLL_25;
								break;
							case "postroll":
								kse.eventType = com.kaltura.types.KalturaStatsEventType.POSTROLL_25;
								break;
							case "overlay":
								//							kse.eventType = com.kaltura.types.KalturaStatsEventType.OVERLAY_STARTED;
								break;
						}
						break;
					case AdsNotificationTypes.MID_OF_AD:
						timeSlot = note.getBody().timeSlot;
						switch (timeSlot) {
							case "preroll":
								kse.eventType = com.kaltura.types.KalturaStatsEventType.PREROLL_50;
								break;
							case "midroll":
								kse.eventType = com.kaltura.types.KalturaStatsEventType.MIDROLL_50;
								break;
							case "postroll":
								kse.eventType = com.kaltura.types.KalturaStatsEventType.POSTROLL_50;
								break;
							case "overlay":
								//							kse.eventType = com.kaltura.types.KalturaStatsEventType.OVERLAY_STARTED;
								break;
						}
						break;
					case AdsNotificationTypes.THIRD_QUARTILE_OF_AD:
						timeSlot = note.getBody().timeSlot;
						switch (timeSlot) {
							case "preroll":
								kse.eventType = com.kaltura.types.KalturaStatsEventType.PREROLL_75;
								break;
							case "midroll":
								kse.eventType = com.kaltura.types.KalturaStatsEventType.MIDROLL_75;
								break;
							case "postroll":
								kse.eventType = com.kaltura.types.KalturaStatsEventType.POSTROLL_75;
								break;
							case "overlay":
								//							kse.eventType = com.kaltura.types.KalturaStatsEventType.OVERLAY_STARTED;
								break;
						}
						break;
				}
			}
			
		}
		
		
		public function get view():DisplayObject {
			return viewComponent as DisplayObject;
		}
		
	}
}