package com.kaltura.kdpfl.plugin.googleAnalytics
{
	import com.google.analytics.GATracker;
	import com.kaltura.commands.stats.StatsCollect;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.types.KalturaStatsEventType;
	import com.kaltura.vo.KalturaStatsEvent;
	
	import flash.display.DisplayObject;
	import flash.net.URLRequestMethod;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * Demonstration mediator class for google analytics events tracking 
	 * @author Zohar Babin
	 */	
	public class GAStatisticsMediator extends Mediator
	{
		
		public var visualDebug:Boolean;
		public var notifications:Array = [
			"hasOpenedFullScreen",
			"hasCloseFullScreen",
			"playerUpdatePlayhead",
			"playerReady",
			"playerEmpty",
			"playerPlayed",
			"mediaReady",
			"durationChange",
			"playerSeekStart",
			"playerSeekEnd",
			"scrubberDragStart",
			"scrubberDragEnd",
			"playerPaused",
			"playerPlayEnd",
			"playerStateChange",
			"changeMedia",
			"kdpReady",
			"gotoEditorWindow",
			"doDownload",
			"doGigya",
			"doSeek",
			"gotoContributorWindow"
		];
		
		
		
		/**
		 *the name of the mediator. 
		 */		
		public static const NAME:String = "gaStatisticsMediator";
		
		// Google Analytics manager.
		private var _ga:GATracker;
		
		/**
		 * The urchin code used by google analytics. 
		 */		
		public var urchinCode : String;
		
		/**
		 *Constructor. 
		 * @param urchin_code		The google analytics tracking code.
		 * @param viewComponent		The ui element to attach the ga debug window to.
		 */		
		public function GAStatisticsMediator(urchin_code : String, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			urchinCode = urchin_code;
		}
		
		/**
		 *puremvc require all mediators override this function and return the list of events the mediator would like to listen on. 
		 * @return 		Array of event names (notifications).
		 */		
		override public function listNotificationInterests():Array
		{
			return  notifications;
		}
		
		/**
		 *Build a generic statistics object for easier tracking. 
		 * @param kc	The Kaltura Client (from the flex Kaltura APIs Client Library).
		 * @return 		A generic Kaltura statistics event.
		 */		
		private function getBasicStatsEntry(kc:Object) : com.kaltura.vo.KalturaStatsEvent
		{
			var config: Object =  facade.retrieveProxy("configProxy");
			var mediaPlayer : Object = facade.retrieveMediator("kMediaPlayerMediator");
			var kse : com.kaltura.vo.KalturaStatsEvent = new com.kaltura.vo.KalturaStatsEvent();
			kse.partnerId = config["vo"]["flashvars"].partnerId;
			kse.widgetId = config["vo"]["flashvars"].id;
            kse.uiconfId = config["vo"].flashvars.uiConfId;
            kse.entryId =  (facade.retrieveProxy("mediaProxy"))["vo"].entry.id;
 		    kse.clientVer = "3.0:" + facade["kdpVersion"];
            var dt:Date = new Date();
            kse.eventTimestamp = dt.time + dt.timezoneOffset-dt.timezoneOffset*60000; // milisec UTC + users timezone offset
            if(mediaPlayer)
            {
		        kse.duration = mediaPlayer["player"].duration;
		        kse.currentPoint = Number(mediaPlayer["player"].currentTime) * 1000;
            }
			kse.sessionId =kc["ks"];            
			kse.referrer = config["vo"].flashvars.referer;
			if(!kse.referrer)			
				kse.referrer = config["vo"].flashvars.refferer;			
			return kse;
		}
		
		/**
		 *All mediators should override this method to respond for the events the mediator is listening on (as defined on listNotificationInterests). 
		 * @param notification	the notification event being handeled.
		 */		
		override public function handleNotification(notification:INotification):void
		{
			var kc: Object =  facade.retrieveProxy("servicesProxy")["kalturaClient"];
			var kse : com.kaltura.vo.KalturaStatsEvent = this.getBasicStatsEntry(kc);
			var data:Object = notification.getBody();
			if (notification.getName() == "playerUpdatePlayhead") {
				if (Math.floor((data as Number) / kse.duration) * 100 % 5 == 0) 
					publishGa(kse.sessionId, notification.getName(),  kse.partnerId.toString() + "/" +  kse.uid + "/" + kse.entryId + "/" +  kse.widgetId + "/" + kse.uiconfId.toString(), kse.currentPoint);
			} else {
				publishGa(kse.sessionId, notification.getName(),  kse.partnerId.toString() + "/" +  kse.uid + "/" + kse.entryId + "/" +  kse.widgetId + "/" + kse.uiconfId.toString(), kse.currentPoint);
			}
		}
		
		/**
		 *setup method for creating the GATracker instance. 
		 * @param urchin_code		The google analytics tracking code.
		 */		
		public function setupGa (urchin_code:String):void {
			urchinCode = urchin_code;
			trace("KDPGA - ga_id: " + urchinCode);
			_ga = new GATracker( view, urchinCode, "AS3", visualDebug);
		}
		
		/**
		 *Tracking method for tracking the events on GATracker. 
		 * @param category		The category of the event.
		 * @param action		The action performed.
		 * @param label			Additional information.
		 * @param value			The value of the action carried.
		 */		
		private function publishGa (category:String, action:String, label:String, value:Number = NaN):void {
			if (_ga) {
				_ga.trackEvent(category, action, label, value);
				trace ("GA tracking: ",category, action, label, value);
			}
		}
		
		/**
		 * The view component for this mediator 
		 */		
		public function get view() : DisplayObject
		{
			return viewComponent as DisplayObject;
		}
		
	}
}