package com.kaltura.kdpfl.plugin.component {
	import com.kaltura.KalturaClient;
	import com.kaltura.commands.stats.StatsCollect;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.type.AdsNotificationTypes;
	import com.kaltura.kdpfl.util.URLProccessing;
	import com.kaltura.kdpfl.util.URLUtils;
	import com.kaltura.types.KalturaStatsEventType;
	import com.kaltura.vo.KalturaStatsEvent;
	
	import flash.display.DisplayObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * Class StatisticsPluginMediator is responsible for "catching" the KDP notifications and translating them to the appropriate statistics events.
	 * @author Hila
	 * 
	 */	
	public class TmMediator extends Mediator {
		
		
		/**
		 * Mediator name 
		 */		
		public static const NAME:String = "TmMediator";
		
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
		/**
		 * Path to TheMarker service 
		 */
		public var path:String = "";
		/**
		 * Constructor 
		 * @param disStats - boolean signifying that the statistics should no be dispatched.
		 * @param viewComponent
		 * 
		 */		
		public function TmMediator(disStats:Boolean, viewComponent:Object = null) {
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
				"playerPlayed", 
				"mediaReady" 
					];
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
		 *  Function responsible for dispatching the appropriate statistics event according to the notification fired by the KDP.
		 * @param note notification fired by the KDP and caught by the Mediator.
		 * 
		 */		
		override public function handleNotification(note:INotification):void {
			if (statsDis)
				return;
			var timeSlot:String;
			var kc:KalturaClient = facade.retrieveProxy("servicesProxy")["kalturaClient"];
			var kse:KalturaStatsEvent = getBasicStatsData(kc.ks);
			var data:Object = note.getBody();
			switch (note.getName()) {

				case "playerPlayed":
					if (_isNewLoad && !_played) {
						_played = true;
						// this is for the marker
						sendExternalHit(false);
					}

					break;


				case "mediaReady":
					
					if (kse.entryId) {
						if (_lastId != kse.entryId) {
							_played = false;
							_lastId = kse.entryId;
							_isNewLoad = true;
							sendExternalHit(true);
						}
						else {
							_isNewLoad = false;
							_lastSeek = 0;
						}
					}
					break;
		
			}
		}
		
		
		/**
		 * Send a hit in 2 cases - view and play. Send 3 parameters:
		 * entryId
		 * entryName
		 * eventType (view/play)
		 * @param isView
		 * 
		 */		
		protected function sendExternalHit(isView:Boolean=false):void
		{
			var req:URLRequest = new URLRequest(path);
			req.method = URLRequestMethod.GET;
			var variables:URLVariables = new URLVariables();
			variables.entryId = _lastId;
			if(isView)
				variables.eventType = "view";
			else
				variables.eventType = "play";
			var mp:*= facade.retrieveProxy("mediaProxy");
			if(mp && mp.vo && mp.vo.entry && mp.vo.entry.name)
				variables.entryName = mp.vo.entry.name;
			req.data = variables;
			if(path)
				var loader:URLLoader = new URLLoader(req);
		}

		public function get view():DisplayObject {
			return viewComponent as DisplayObject;
		}

	}
}