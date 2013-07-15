package com.kaltura.kdpfl.plugin.component {
	import com.kaltura.KalturaClient;
	import com.kaltura.commands.stats.StatsCollect;
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.kdpfl.model.ExternalInterfaceProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.AdsNotificationTypes;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.types.KalturaStatsEventType;
	import com.kaltura.vo.KalturaStatsEvent;
	
	import flash.display.DisplayObject;
	import flash.external.ExternalInterface;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	import org.osmf.media.MediaPlayerState;
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
		
		private var _kc : KalturaClient;
		
		private var _bufferStarted:Boolean = false;
		
		/**
		 * if set to true buffer_start and buffer_end events won't be sent 
		 */		
		public var bufferStatsDis:Boolean = false;
		
		private var _mediaProxy:MediaProxy;
		
		public var trackEventMonitor:String;

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
				NotificationType.HAS_OPENED_FULL_SCREEN, 
				NotificationType.HAS_CLOSED_FULL_SCREEN, 
				NotificationType.PLAYER_UPDATE_PLAYHEAD,  
				NotificationType.PLAYER_PLAYED, 
				NotificationType.MEDIA_READY,  
				NotificationType.PLAYER_SEEK_END, 
				NotificationType.SCRUBBER_DRAG_START, 
				NotificationType.SCRUBBER_DRAG_END, 
				NotificationType.PLAYER_STATE_CHANGE, 
				NotificationType.KDP_READY,
				NotificationType.KDP_EMPTY,
				NotificationType.DO_SEEK, 
				"gotoEditorWindow", 
				"doDownload", 
				"doGigya",
				"showAdvancedShare",
				"gotoContributorWindow",
				"flagForReview",
				AdsNotificationTypes.AD_START, 
				AdsNotificationTypes.AD_CLICK, 
				AdsNotificationTypes.BUMPER_STARTED, 
				AdsNotificationTypes.BUMPER_CLICKED,
				AdsNotificationTypes.FIRST_QUARTILE_OF_AD,
				AdsNotificationTypes.MID_OF_AD,
				AdsNotificationTypes.THIRD_QUARTILE_OF_AD,
				NotificationType.DO_REPLAY
			];
		}
		
		override public function onRegister():void 
		{
			_flashvars = facade.retrieveProxy("configProxy")["vo"]["flashvars"];
			_mediaProxy = facade.retrieveProxy("mediaProxy") as MediaProxy;
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
			kse.partnerId = _flashvars.partnerId;
			kse.widgetId = _flashvars.id;
			kse.uiconfId = _flashvars.uiConfId;
			// this is where we choose the entry to report on
			if (_mediaProxy.vo.entry.id)
				kse.entryId = _mediaProxy.vo.entry.id;
			kse.clientVer = "3.0:" + facade["kdpVersion"];
			var dt:Date = new Date();
			kse.eventTimestamp = dt.time + dt.timezoneOffset - dt.timezoneOffset * 60; // milisec UTC + users timezone offset
			if (mediaPlayer) {
				kse.duration = mediaPlayer["player"].duration;
				kse.currentPoint = Number(mediaPlayer.getCurrentTime()) * 1000;
			}
			kse.sessionId = config["vo"]["sessionId"];
			kse.seek = _hasSeeked;
			kse.referrer = _flashvars.referer;
			if (!kse.referrer)
				kse.referrer = _flashvars.refferer;
			// verify the the referrer is escaped once
			kse.referrer = escape(unescape(kse.referrer));
			
			if (_flashvars.playbackContext)
				kse.contextId = _flashvars.playbackContext;
			if (_flashvars.originFeature)
				kse.featureType = _flashvars.originFeature;
			if (_flashvars.applicationName)
				kse.applicationId = _flashvars.applicationName;
			if (_flashvars.userId)
				kse.userId = _flashvars.userId;
			
			return kse;
		}

		/**
		 * Function checks whether a progress statistics event should be dispathced.
		 * @param currPosition	current playhead position
		 * @param duration		media duration
		 * @return 	event type code, or -1 if none matched
		 * 
		 */
		private function percentStatsChanged(currPosition:Number, duration:int):String {

			var percent:Number = 0;
			var seekPercent:Number = 0;

			if (_inDrag || _inFF || _mediaProxy.vo.isLive) {
				return null;
			}

			if (duration > 0) {
				percent = currPosition / duration;
				seekPercent = _lastSeek / duration;
			}

			if (!_p25Once && Math.round(percent * 100) >= 25 && seekPercent < 0.25) {
				_p25Once = true;
				return "PLAY_REACHED_25";
			}
			else if (!_p50Once && Math.round(percent * 100) >= 50 && seekPercent < 0.50) {
				_p50Once = true;
				return "PLAY_REACHED_50";
			}
			else if (!_p75Once && Math.round(percent * 100) >= 75 && seekPercent < 0.75) {
				_p75Once = true;
				return "PLAY_REACHED_75";
			}
			else if (!_p100Once && Math.round(percent * 100) >= 98 && seekPercent < 1) {
				_p100Once = true;
				return "PLAY_REACHED_100";
			}

			return null;
		}

		/**
		 *  Function responsible for dispatching the appropriate statistics event according to the notification fired by the KDP.
		 * @param note notification fired by the KDP and caught by the Mediator.
		 * 
		 */		
		override public function handleNotification(note:INotification):void {
			var eventName:String;
			if (statsDis)
				return;
			var timeSlot:String;
			//var _kc:KalturaClient = facade.retrieveProxy("servicesProxy")["kalturaClient"];		
			var kse:KalturaStatsEvent = getBasicStatsData(_kc.ks);
			var data:Object = note.getBody();
			
			var sequenceProxy : SequenceProxy = facade.retrieveProxy( SequenceProxy.NAME ) as SequenceProxy;
			
			if (sequenceProxy.vo.isInSequence)
			{
				//bumper plugin case - send play & play through statistics
				if (sequenceProxy.activePlugin() && 
					sequenceProxy.activePlugin().sourceType=="entryId" && 
					(note.getName()==NotificationType.MEDIA_READY || note.getName()==NotificationType.PLAYER_PLAYED || note.getName()==NotificationType.PLAYER_UPDATE_PLAYHEAD))
				{
					handleMainContentNotifications();
					
				}
				else
				{
					handleAdsNotifications();
				}
			}
			else
			{
				handleMainContentNotifications();
			}
			
			// if we enter this function for any wrong reason and we don't have event to send, just return...
			if (!eventName || eventName == "") {
				return;
			}
			else {
				kse.eventType = KalturaStatsEventType[eventName];
			}
			
			var collect:StatsCollect = new StatsCollect(kse);
			collect.method = URLRequestMethod.GET;
			_kc.post(collect);
			//notify js
			if ((facade.retrieveProxy(ExternalInterfaceProxy.NAME) as ExternalInterfaceProxy).vo.enabled
				&&trackEventMonitor && 
				trackEventMonitor!="" ) 
			{
				try {
					ExternalInterface.call(trackEventMonitor, eventName, kse);
				}
				catch (e:Error) {
					//
				}
			}
				
			
			
			
			function handleMainContentNotifications () : void
			{
				switch (note.getName()) 
				{
					case NotificationType.HAS_OPENED_FULL_SCREEN:
						if (_fullScreen == false) {
							eventName = "OPEN_FULL_SCREEN";
						}
						_fullScreen = true;
						_normalScreen = false;
						break;
					case NotificationType.HAS_CLOSED_FULL_SCREEN:
						if (_normalScreen == false) {
							eventName = "CLOSE_FULL_SCREEN";
						}
						_fullScreen = false;
						_normalScreen = true;
						break;
	
					case NotificationType.KDP_EMPTY:
						if (_ready)
							return;
						eventName = "WIDGET_LOADED";
						_ready = true;
						break;
	
					case NotificationType.PLAYER_PLAYED:
						
						
						//In the case of a bumper entry, the bumper has already reported PLAYER_PLAYED for the 
						//statistics "session" of the real entry, which causes wrong input of analytics.
						if (_lastId != kse.entryId) {
							_played = false;
							_lastId = kse.entryId;
						}
						
						if (!_played) {
							eventName = "PLAY";
							_p25Once = false;
							_p50Once = false;
							_p75Once = false;
							_p100Once = false;
							_played = true;
						}
	
						break;
	
	
					case NotificationType.MEDIA_READY:
						
						if (kse.entryId) {
							if (_lastId != kse.entryId) {
								_played = false;
								_lastId = kse.entryId;
								_hasSeeked = false;
								eventName = "MEDIA_LOADED";
							}
							else {
								_lastSeek = 0;
							}
						}
						break;
					
					case NotificationType.PLAYER_SEEK_END:
						_inSeek = false;
						return;
						break;
	
					case NotificationType.SCRUBBER_DRAG_START:
						_inDrag = true;
						return;
						break;
	
					case NotificationType.SCRUBBER_DRAG_END:
						_inDrag = false;
						_inSeek = false;
						return;
						break;
	
					case NotificationType.PLAYER_UPDATE_PLAYHEAD:
						
							eventName = percentStatsChanged(data as Number, kse.duration);
							if (!eventName) {
								return; // negative number means no need to change update
							}
							break;
	
					case NotificationType.KDP_READY:
						// Ready should not occur more than once
						if (_ready)
							return;
						eventName = "WIDGET_LOADED";
						_ready = true;
						break;
					case "gotoEditorWindow":
						eventName = "OPEN_EDIT";
						break
					case "doDownload":
						eventName = "OPEN_DOWNLOAD";
						break;
					case "doGigya":
					case "showAdvancedShare":
						eventName = "OPEN_VIRAL";
						break;
					case "flagForReview":
						eventName = "OPEN_REPORT";
						break;
					case NotificationType.DO_SEEK:
						if (_inDrag && !_inSeek) {
							eventName = "SEEK";
						}
						_lastSeek = Number(note.getBody());
						_inSeek = true;
						_hasSeeked = true;
						break;
					
					case "gotoContributorWindow":
						eventName = "OPEN_UPLOAD";
						break;
					
					case NotificationType.PLAYER_STATE_CHANGE:
						if (!bufferStatsDis)
						{
							if (note.getBody() == MediaPlayerState.BUFFERING)
							{
								if (!_bufferStarted)
								{
									eventName = "BUFFER_START";
									_bufferStarted = true;
								}
							}
							else if (_bufferStarted)
							{
								eventName = "BUFFER_END";
								_bufferStarted = false;
							}
						}	
						break;
					
					case NotificationType.DO_REPLAY:
						eventName = "REPLAY";
						break;
				}
			}
					
			function handleAdsNotifications ()  : void
			{
				
				switch (note.getName())
				{
					case AdsNotificationTypes.BUMPER_CLICKED:
						eventName = "BUMPER_CLICKED";
						break;
					case AdsNotificationTypes.BUMPER_STARTED:
						if (note.getBody().timeSlot == "preroll") {
							eventName = "PRE_BUMPER_PLAYED";
						}
						else if (note.getBody().timeSlot == "postroll") {
							eventName = "POST_BUMPER_PLAYED";
						}
						break;
					case AdsNotificationTypes.AD_CLICK:
						timeSlot = note.getBody().timeSlot;
						switch (timeSlot) {
							case "preroll":
								eventName = "PREROLL_CLICKED";
								break;
							case "midroll":
								eventName = "MIDROLL_CLICKED";
								break;
							case "postroll":
								eventName = "POSTROLL_CLICKED";
								break;
							case "overlay":
								eventName = "OVERLAY_CLICKED";
								break;
							
						}
						break;
					case AdsNotificationTypes.AD_START:
						timeSlot = note.getBody().timeSlot;
						switch (timeSlot) {
							case "preroll":
								eventName = "PREROLL_STARTED";
								break;
							case "midroll":
								eventName = "MIDROLL_STARTED";
								break;
							case "postroll":
								eventName = "POSTROLL_STARTED";
								break;
							case "overlay":
								eventName = "OVERLAY_STARTED";
								break;
						}
						break;
					case AdsNotificationTypes.FIRST_QUARTILE_OF_AD:
						timeSlot = note.getBody().timeSlot;
						switch (timeSlot) {
							case "preroll":
								eventName = "PREROLL_25";
								break;
							case "midroll":
								eventName = "MIDROLL_25";
								break;
							case "postroll":
								eventName = "POSTROLL_25";
								break;
							case "overlay":
	//							eventName = "OVERLAY_STARTED";
								break;
						}
						break;
					case AdsNotificationTypes.MID_OF_AD:
						timeSlot = note.getBody().timeSlot;
						switch (timeSlot) {
							case "preroll":
								eventName = "PREROLL_50";
								break;
							case "midroll":
								eventName = "MIDROLL_50";
								break;
							case "postroll":
								eventName = "POSTROLL_50";
								break;
							case "overlay":
	//							eventName = "OVERLAY_STARTED";
								break;
						}
						break;
					case AdsNotificationTypes.THIRD_QUARTILE_OF_AD:
						timeSlot = note.getBody().timeSlot;
						switch (timeSlot) {
							case "preroll":
								eventName = "PREROLL_75";
								break;
							case "midroll":
								eventName = "MIDROLL_75";
								break;
							case "postroll":
								eventName = "POSTROLL_75";
								break;
							case "overlay":
	//							eventName = "OVERLAY_STARTED";
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