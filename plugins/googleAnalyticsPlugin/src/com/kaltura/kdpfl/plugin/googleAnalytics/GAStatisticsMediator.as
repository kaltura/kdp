package com.kaltura.kdpfl.plugin.googleAnalytics
{
	import com.google.analytics.GATracker;
	import com.google.analytics.core.RequestObject;
	import com.kaltura.commands.stats.StatsCollect;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.types.KalturaStatsEventType;
	import com.kaltura.vo.KalturaBaseEntry;
	import com.kaltura.vo.KalturaStatsEvent;
	
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.sendToURL;
	import flash.text.engine.BreakOpportunity;
	import flash.utils.Timer;
	
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
			NotificationType.OPEN_FULL_SCREEN,
			NotificationType.HAS_OPENED_FULL_SCREEN,
			NotificationType.CLOSE_FULL_SCREEN,
			NotificationType.HAS_CLOSED_FULL_SCREEN,
//			NotificationType.PLAYER_READY,
			NotificationType.MEDIA_READY,
			NotificationType.CHANGE_MEDIA,
			NotificationType.PLAYER_PLAYED,
			NotificationType.PLAYER_UPDATE_PLAYHEAD,
			NotificationType.PLAYER_PLAY_END,
			NotificationType.DO_PAUSE,
			NotificationType.DO_REPLAY,
			NotificationType.DURATION_CHANGE,
			"kdpReady",
			"doDownload",
			"doGigya",
			"adEnd",
			"doSeek",
			"playerEmpty"];
		
		
		
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
		
		public var defaultCategory:String;
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
			log("[GoogleAnalyticsPlugin.swf] Notifications: "+notifications);
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
		
		private var _firstPlay:Boolean		= true;
		private var _isInFullscreen:Boolean	= false;
		private var _playheadTimer:Timer;
		public var playheadFrequency:Number;
		private var _blockUpdatePlayhead:Boolean	= false;
		private var _currentTime:Number		= 0;
		private var _percentages:Array;
		private var _nextCuePoint:Number = -1; 
		private var _duration:Number = 0;
		/**
		 * iFlag indicating that the scrubber is being dragged.
		 */		
		private var _inDrag:Boolean = false;
		/**
		 * Flag indicating that is a seek operation is on-going.
		 */		
		private var _inSeek:Boolean = false;
		
		
		/**
		 *All mediators should override this method to respond for the events the mediator is listening on (as defined on listNotificationInterests). 
		 * @param notification	the notification event being handeled.
		 */		
		override public function handleNotification(notification:INotification):void
		{
			
			var kc: Object =  facade.retrieveProxy("servicesProxy")["kalturaClient"];
			var sp: SequenceProxy =  (facade.retrieveProxy("sequenceProxy") as SequenceProxy);
			var kse : com.kaltura.vo.KalturaStatsEvent = this.getBasicStatsEntry(kc);
			var kw:Object	= facade.retrieveProxy("configProxy")["vo"]["kw"];
			var entry : KalturaBaseEntry  	= (facade.retrieveProxy("mediaProxy")["vo"]["entry"] as KalturaBaseEntry);
			var data:Object = notification.getBody();
			var note:String	= notification.getName();
			var value:Number;
			var customObject:Object		= new Object;
			//some events require additional routines to determine if it should publish to GA.  
			var shouldPublish:Boolean 	= true;
			switch(note){
				case "kdpReady":
					/*
					//stop tracking pageview
					var siteUrl:String	= facade.retrieveProxy("configProxy")["vo"]["flashvars"]["referer"];
					var playerId:String	= kw.id;
					var videoId:String	= entry.id;
					var videoName:String= entry.name;
					var url:String		= siteUrl;
					var refUrl			= siteUrl;
					var requestUrl:String	= siteUrl+"/playerid="+kw.id+"/videoid="+entry.id+"/videoname="+entry.name+"/url="+siteUrl+"/refurl="+siteUrl;
					_ga.trackPageview(requestUrl);
					*/
					break; 
				case NotificationType.DO_REPLAY:
					//per request in 0014539 - reset the percentReached array
					_percentages = new Array();
					for (var k:uint=1 ; k<4 ; k++)
					{
						// create an array of precentages "cue points"
						_percentages.push([Math.ceil(_duration*k)/4,k*25]);	
					}
					_nextCuePoint = _percentages[0][0];

					break;
				case NotificationType.PLAYER_UPDATE_PLAYHEAD:
					if(!sp.vo.isInSequence)
						_currentTime = data as Number;
					
					percentStatsChanged(_currentTime);
					
					//never publish - self timer will decide when to publish
					shouldPublish		= false;
					break;
				case NotificationType.DO_REPLAY:
					break;
				case NotificationType.PLAYER_PLAYED:
					if(_firstPlay && !sp.vo.isInSequence){
						value		= 1;
						_firstPlay		= false;
					}else{
						shouldPublish = false;
					}
					break;
				case NotificationType.PLAYER_PLAY_END:
					_nextCuePoint = -1;
					note		= "100_pct_watched";
					value		= Math.ceil(_duration);
					break;
				case NotificationType.OPEN_FULL_SCREEN:
					value	= 1;
					(_isInFullscreen)?shouldPublish	= false:_isInFullscreen	= true;
					break;
				case NotificationType.HAS_OPENED_FULL_SCREEN:
					value	= 1;
					(_isInFullscreen)?shouldPublish	= false:_isInFullscreen	= true;
					if(shouldPublish)note			= NotificationType.OPEN_FULL_SCREEN;
					break;
				case NotificationType.CLOSE_FULL_SCREEN:
					value	= 1;
					(!_isInFullscreen)?shouldPublish	= false:_isInFullscreen	= false;
					break;
				case NotificationType.HAS_CLOSED_FULL_SCREEN:
					value	= 1;
					(!_isInFullscreen)?shouldPublish	= false:_isInFullscreen	= false;
					if(shouldPublish)note			= NotificationType.CLOSE_FULL_SCREEN;
					break;
				case NotificationType.DURATION_CHANGE:
					_duration = Number(data.newValue);
					if(_duration)
					{
						_percentages = new Array();
						for (var i:uint=1 ; i<4 ; i++)
						{
							// create an array of precentages "cue points"
							_percentages.push([Math.ceil(_duration*i)/4,i*25]);	
						}
						_nextCuePoint = _percentages[0][0];
						//trace("nextCuePoint",_percentages[0][0] ,_percentages[0][1] )
					}
					shouldPublish	= false;
					break;
				case NotificationType.CHANGE_MEDIA:
					value	= 1;
					_firstPlay		= true;
					break;
				case "doDownload":
					value	= 1;
					break;
				case "doGigya":
					value	= 1;
					break;
				case "doSeek":
					_nextCuePoint=-1;
					shouldPublish 	= false;
					break;
				case "playerSeekEnd":
					var mediaPlayer:Object = facade.retrieveMediator("kMediaPlayerMediator");
					_nextCuePoint=-1;
					_inSeek = false;
					percentStatsChanged(mediaPlayer["player"].currentTime);
					shouldPublish	= false;
					break;
				default:
					if(!value)value = NaN;
					customObject					= getCustomProperties(note);
					break;
			}
			
			var gaCategory:String	= customObject["Category"] || defaultCategory;
			var	gaLabel:String		= customObject["Label"] || (entry.name +" | "+entry.id+" | "+kw.id);
			var	gaAction:String		= customObject["Action"] || note;
			var	gaValue:Number		= customObject["Value"] || value;
			
			//TODO: check and see which id is used : widgetId or kw.id
			if(shouldPublish){
				publishGa(gaCategory, gaAction, gaLabel, gaValue);
			}
			
			/**
			 * Function checks whether a progress statistics event should be dispathced.
			 * @param currPosition	current playhead position
			 * 
			 */
			function percentStatsChanged(currPosition:Number):void {
				if (_nextCuePoint==-1)
				{
					if(_percentages.length == 0 || (_duration - currPosition) < 3 )
						return;
					// in case this is the last gap (seek after the last cue point)
					if(currPosition > _percentages[_percentages.length-1][0])
						return;
					
					_nextCuePoint = _percentages[0][0];
					
					//look for the next future cue point
					for(var i:Number =0 ; i<_percentages.length ; i++)
					{
						//trace(currPosition , "VS" , percentages[i][0] )
						if(currPosition<=_percentages[i][0])
						{
							_nextCuePoint = _percentages[i][0];
							break;
						}						
					}
					//trace("nextCuePoint",nextCuePoint  )
				}
				//see if we are passing through the nextCuePoint
				if(!_inDrag && !_inSeek && currPosition > _nextCuePoint && _nextCuePoint> 0  )
				{
					//went pass a cue point
					for  (var s:Number = 0 ; s<_percentages.length ; s++)
					{
						if (_nextCuePoint == _percentages[s][0])
						{
							if(currPosition ) 
							{
								//trace("Reached " ,_percentages[s][0],"wich is",_percentages[s][1]+"%")
								// passing through a precentage cue point
								//TODO:BEACON EVENT
								//							sendStatsData('percentReached',_percentages[s][1])
								//trace( "%%% " , s , percentages.length )25_pct_watched
								publishGa (defaultCategory, _percentages[s][1]+"_pct_watched",  entry.name +" | "+entry.id+" | "+kw.id, Math.round(_currentTime))
								trace("PERCENTAGE REACHED!!!!!!			"+_percentages[s][1]);
								if(_percentages.length == s+1)
								{
									_percentages.splice(s,1);
									_nextCuePoint = -2; // last % in the list
									return;
								}
							}
							
							_percentages.splice(s,1);
							_nextCuePoint = -1;
							return;
						}
						
					}
					
				}
				
			}
			
			
		}
		

		
		
		private function getCustomProperties(key:String):Object{
			var response:Object		= new Object();
			var plugin:Object		= facade["bindObject"]["googleAnalytics"];
			try{	
				response["Value"]	= null;
				response["Action"]	= null;
				response["Label"]	= null;
				response["Category"]= null;
				
				for (var s:String in plugin){
					if(s.indexOf(key) > -1){
						if(s.indexOf("Category") > -1) response["Category"]	= plugin[s];
						if(s.indexOf("Label") > -1) response["Label"]		= plugin[s];
						if(s.indexOf("Action") > -1) response["Action"]		= plugin[s];
						if(s.indexOf("Value") > -1) response["Value"]		= Math.round(Number(plugin[s]));
					}
				}
				log("[GoogleAnalyticsPlugin.swf] Custom Properties - Category 	:"+response["Category"]);
				log("[GoogleAnalyticsPlugin.swf] Custom Properties - Action 	:"+response["Action"]);
				log("[GoogleAnalyticsPlugin.swf] Custom Properties - Label 		:"+response["Label"]);
				log("[GoogleAnalyticsPlugin.swf] Custom Properties - Value 		:"+response["Value"]);
				//log("[GoogleAnalyticsPlugin.swf] Custom Properties - ObjectCount  :"+objCount);
			}catch(e:Error){
				log("[GoogleAnalyticsPlugin.swf] - ERROR : unable to find node with id 'googleAnalytics' in uiConf");
				response	= null;
			}
			return response;
		}
		
		/**
		 *setup method for creating the GATracker instance. 
		 * @param urchin_code		The google analytics tracking code.
		 */		
		public function setupGa (urchin_code:String):void {
			urchinCode = urchin_code;
			log("KDPGA - ga_id: " + urchinCode);
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
			if (_ga && value) 
				_ga.trackEvent(category, action, label, value);
			else if(_ga)
				_ga.trackEvent(category, action, label);
			
			log ("GA tracking************************: "+category+" "+ action+" "+ label+" "+ value);
		}
		
		private function log(str:String):void{
			if(visualDebug)trace(str);
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