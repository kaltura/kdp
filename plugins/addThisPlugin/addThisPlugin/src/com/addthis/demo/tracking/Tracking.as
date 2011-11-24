/*
 	Google Analytics Wrapper	
 	Source: lib/ga/src
 
	Note: We modified the method _addIfNotEmpty 
	in com/google/analytics/campaign/CampaignTracker.as
	to fix a null error issue when the widget swf was
	shared to iGoogle. 
	  
	To read more about why we made this change please refer to
	http://code.google.com/p/gaforflash/issues/detail?id=45
*/
package com.addthis.demo.tracking {
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	
	public class Tracking extends EventDispatcher {
		// Tracked Play Event
		private var EVENT_PLAY:Object = { category:'Videos', action:'Play', opt_label:'AddThis Embeddable Demo' };
		// Tracked Pause Event
		private var EVENT_PAUSE:Object = { category:'Videos', action:'Pause', opt_label:'AddThis Embeddable Demo' };
		// Tracked Replay Event
		private var EVENT_REPLAY:Object = { category:'Videos', action:'Replay', opt_label:'AddThis Embeddable Demo' };
		// Tracked Video Loaded Event
		private var EVENT_VIDEO_LOADED:Object = { category:'Videos', action:'Load', opt_label:'AddThis Embeddable Demo', opt_value:0 };
		// Tracked Page View
		private var VIEW_PAGE:String = 'pages/embedded-example';
		//
		/*	
        	Google Analytics
        	
        	PLEASE ENTER YOUR webPropertyId IF YOU WOULD 
        	LIKE YOUR OWN TRACKING 
        	
        	webPropertyId='UA-111-222' is Google default
        */
        private var _tracker:AnalyticsTracker; 
        private var _trackerPropertyId:String = 'UA-1170033-7';
        private var _trackerMode:String = 'AS3' // value = Bridge or AS3
        private var _trackerDebug:Boolean = false;
        private var _callingDisplayObject:DisplayObject;
		
		public function Tracking(value:DisplayObject=null) {
			super();
			if (value)
				_callingDisplayObject = value; 
				
			_tracker = new GATracker(_callingDisplayObject, _trackerPropertyId, _trackerMode, _trackerDebug);
		}
			
		public function trackEvent(value:String, opt_value:*=NaN):void {
			var tmp:Object;
			switch(value) {
				case 'play':
					tmp = EVENT_PLAY;
					break;
				case 'pause':
					tmp = EVENT_PAUSE;
					break;
				case 'replay':
					tmp = EVENT_REPLAY;
					break;
				case 'loaded':
					tmp = EVENT_VIDEO_LOADED;
					break;
			}
			if (opt_value is Number) {
				tmp.opt_value = opt_value;
				_tracker.trackEvent(tmp.category, tmp.action, tmp.opt_label, tmp.opt_value);
			} else {
				tmp.opt_value = NaN;
				_tracker.trackEvent(tmp.category, tmp.action, tmp.opt_label);
			}
			
			trace('_tracker.trackEvent(', tmp.category,', ',tmp.action,', ',tmp.opt_label,', ',tmp.opt_value,');');
		}
		public function trackPageView():void {
			_tracker.trackPageview(VIEW_PAGE);
		}
	}
}