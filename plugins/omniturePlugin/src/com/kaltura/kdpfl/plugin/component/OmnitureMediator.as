package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.model.ExternalInterfaceProxy;
	import com.kaltura.vo.KalturaPlayableEntry;
	import com.omniture.AppMeasurement;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class OmnitureMediator extends Mediator
	{
		/**
		 * mediator name 
		 */		
		public static const NAME:String = "omnitureMediator";
		
		private var _ready:Boolean = false;
		private var _inSeek:Boolean = false;
		private var _inDrag:Boolean = false;
		private var _inFF:Boolean = false;
		private var _p25Once:Boolean = false;
		private var _p50Once:Boolean = false;
		private var _p75Once:Boolean = false;
		private var _p100Once:Boolean = false;
		private var _played:Boolean = false;
		private var _wasBuffering:Boolean = false;
		private var _hasSeeked:Boolean = false;
		private var _isReplay:Boolean = false;
		private var _mediaIsLoaded:Boolean=false;
		private var _fullScreen:Boolean=false;
		private var _normalScreen:Boolean=false;
		private var _lastSeek:Number=0;
		private var _playheadPosition:Number=0;
		private var _lastId : String = "";
		private var _isNewLoad : Boolean = false;
		private var _mediaName : String;
		private var _duration : Number;
		
		public var dynamicConfig:String;
		public var debugMode:String;
		
		public var charSet:String = "UTF-8";
		public var currencyCode:String = "USD";
		public var dc:String = "122";
		public var eventDispatcher : EventDispatcher = new EventDispatcher();
		
		public static const VIDEO_VIEW_EVENT:String = "videoViewEvent";
		public static const SHARE_EVENT:String = "shareEvent";
		public static const OPEN_FULL_SCREEN_EVENT:String = "openFullscreenEvent";
		public static const CLOSE_FULL_SCREEN_EVENT:String = "closefullscreenEvent";
		public static const SAVE_EVENT:String = "saveEvent";
		public static const REPLAY_EVENT:String = "replayEvent";
		public static const SEEK_EVENT:String = "seekEvent";
		public static const CHANGE_MEDIA_EVENT:String = "changeMediaEvent";
		public static const GOTO_CONTRIBUTOR_WINDOW_EVENT:String = "gotoContributorWindowEvent";
		public static const GOTO_EDITOR_WINDOW_EVENT:String = "gotoEditorWindowEvent";
		public static const PLAYER_PLAY_END_EVENT:String = "playerPlayEndEvent";
		public static const MEDIA_READY_EVENT:String = "mediaReadyEvent";
		public static const WATERMARK_CLICK:String = "watermarkClick";
		private	var eip:ExternalInterfaceProxy = Facade.getInstance().retrieveProxy("externalInterfaceProxy") as ExternalInterfaceProxy;
		
		private var _isReady:Boolean = false;
		 
		/**
		 * disable statistics 
		 */		
		public var statsDis : Boolean;
		
		/**
		 * Omniture account 
		 */		
		public var account  :String;
		
		/**
		 * Omniture visitor namespace 
		 */		
		public var visitorNamespace  :String;
		
		/**
		 * Omniture tracking server 
		 */		
		public var trackingServer  :String;
		
		/**
		 * entry percents to track 
		 */		
		public var trackMilestones  :String;
		/**
		 * Custom general events 
		 */
		public var customEvents:Array = new Array();
		
		public var s:AppMeasurement;
		private var cp:Object;
		
		/**
		 * Constructor. 
		 */		
		public function OmnitureMediator(customEvents:Array)
		{
			if (customEvents)
			{
				this.customEvents = customEvents;
			}
			super(NAME);
		}
		
		/**
		* External interface to extract the suit from the page	
		*/
		private function getOmniVar(omnivar:String):String {
			
			//TODO - pass this through the ExternalInterfaceProxy once it will 
			return ExternalInterface.call("function() { return "+omnivar+";}");
		}
		
		/**
		 * After all parameters are set - init the AppMeasurement object
		 */
		public function init():void
		{
			var f:Object = Facade.getInstance();
			s = new AppMeasurement();
			//this feature allows to extract the configuration from the page
			if(dynamicConfig == "true")
			{
				eip.addCallback("omnitureKdpJsReady",omnitureKdpJsReady);
				return;
			}	else
			{
				if(visitorNamespace.indexOf("*")>-1)
					visitorNamespace.split("*").join(".");
				s.visitorNamespace = visitorNamespace;
				s.trackingServer = trackingServer;
				s.account = account;
				s.charSet = charSet;
				s.currencyCode = currencyCode;
			}
			prepareAppMeasurement();
		}
		public function omnitureKdpJsReady():void
		{
			s.visitorNamespace = getOmniVar("com.TI.Metrics.tcNameSpace");
			s.trackingServer = getOmniVar("com.TI.Metrics.tcTrackingServer");
			s.account = getOmniVar("com.TI.Metrics.tcReportSuiteID");
			s.charSet = getOmniVar("com.TI.Metrics.tcCharSet");
			s.currencyCode = getOmniVar("com.TI.Metrics.tcCurrencyCode");
			prepareAppMeasurement(); 
		}
		 
		/**
		 * Prepare the AppMeasurement attributes and turn on the flag that sais that this is ready. 
		 */
		private function prepareAppMeasurement():void
		{
			cp = Facade.getInstance().retrieveProxy("configProxy");
			s.dc = dc;
			s.debugTracking = debugMode =="true" ? true : false ;
			s.trackLocal = true;
			s.Media.trackWhilePlaying = true;
			s.pageName = cp.vo.flashvars.referer;
			s.pageURL = cp.vo.flashvars.referer;
			s.Media.trackMilestones = trackMilestones;
			s.trackClickMap = true;
			if(cp.vo.kuiConf && cp.vo.kuiConf.name)
				s.Media.playerName= cp.vo.kuiConf.name;
			else
				s.Media.playerName= 'localPlayer';
			_isReady = true;
		}
		
		private function onAddedToStage(evt:Event):void
		{
			(viewComponent as DisplayObjectContainer).addChild(s);
		}
		
		/**
		 * Hook to the relevant KDP notifications
		 */
		override public function listNotificationInterests():Array
		{
			
			var notificationsArray:Array =  [
												"hasOpenedFullScreen",
												"hasCloseFullScreen",
												"playerUpdatePlayhead",
												"playerReady",
												"playerPlayed",
												"mediaReady",
												"durationChange",
												"fastForward",
												"stopFastForward",
												"playerSeekStart",
												"playerSeekEnd",
												"scrubberDragStart",
												"scrubberDragEnd",
												"playerPaused",
												"playerPlayEnd",
												"changeMedia",
												"doGigya",
												"doDownload",
												"watermarkClick",
												"doReplay",
												"doPause",
												"doPlay",
												"kdpReady",
												"doSeek"
											];

			notificationsArray = notificationsArray.concat(customEvents);
			return notificationsArray;
		}
		
	
		/**
		 * @inheritDocs
		 */		
		override public function handleNotification(note:INotification):void
		{
			if (statsDis) return;
			//trace("in handle notification: ", note.getName());
			var kc: Object =  facade.retrieveProxy("servicesProxy")["kalturaClient"];
			var data:Object = note.getBody();
			switch(note.getName())
			{
				case "playerReady":
				//this is useless since the event happens before the OmniturePlugin is ready for use
				//TOCHECK - do we neeed this ? ANswer - not at the current!  
				//sendGeneralNotification("widgetLoaded");
				break;
				
				case "hasOpenedFullScreen":
				 if(_fullScreen==false)
				 {
					sendGeneralNotification(OPEN_FULL_SCREEN_EVENT);
				 }
				_fullScreen=true;
				_normalScreen=false;	
				break;
				case "hasCloseFullScreen":
				if(_normalScreen==false)
				{
					sendGeneralNotification(CLOSE_FULL_SCREEN_EVENT);
				}
				_fullScreen=false;
				_normalScreen=true;	
				break;
				case "watermarkClick":
				case "playerPlayEnd":
					s.Media.close(cp.vo.kuiConf.name);
					sendGeneralNotification(PLAYER_PLAY_END_EVENT);
				break;
				case "playerPlayed":
					if (_isNewLoad && !_played)
					{
						//kse.eventType = com.kaltura.types.KalturaStatsEventType.PLAY;
						s.Media.play(_mediaName,_playheadPosition);
						sendGeneralNotification(VIDEO_VIEW_EVENT);
						_played = true;
					}
				break; 
				case "doDownload":
					sendGeneralNotification(SAVE_EVENT);
				break; 
				case "doGigya":
					sendGeneralNotification(SHARE_EVENT);
				break; 
				case "mediaReady":
				    if((facade.retrieveProxy("mediaProxy"))["vo"].entry.id){
				    	if (_lastId != (facade.retrieveProxy("mediaProxy"))["vo"].entry.id)
				    	{
							_mediaName = (facade.retrieveProxy("mediaProxy"))["vo"].entry.name;
							var media:KalturaPlayableEntry = (facade.retrieveProxy("mediaProxy"))["vo"].entry;
							_duration = media.duration;
				    		_played = false;
				    		_lastId = (facade.retrieveProxy("mediaProxy"))["vo"].entry.id;
				    		_isNewLoad = true; 
							sendGeneralNotification(MEDIA_READY_EVENT);
				    	}
				    	else
				    	{
				    		_isNewLoad = false;
				    		_lastSeek = 0;
				    	}
				    	_mediaIsLoaded=true;
				    }
					s.movieID = _lastId;
					if(media)
					{
						s.Media.open(_mediaName,media.duration, cp.vo.kuiConf.name);
					}
					
					
				break;
							
				case "durationChange":
					if(_isNewLoad){
						_hasSeeked = false;
					}
					return;
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
					_playheadPosition = data as Number;

				break;
				
				case "kdpReady":
				//Ready should not occur more than once
					if (_ready) return;
					_ready = true;
				break;
				case "doSeek":
					_lastSeek = Number(note.getBody());

					if(_inDrag && !_inSeek && !_isReplay)
					{
						sendGeneralNotification(SEEK_EVENT);
					}
					_inSeek = true;
					_hasSeeked = true;
					_isReplay = false;
				break;
				
				case "doReplay":
					sendGeneralNotification(REPLAY_EVENT); //TODO, fix the seek event being sent after replay. at the current this relies on the replay command happening before the seek  
					_isReplay = true;
				break;
				case "doPlay":
					s.Media.play(_mediaName,_playheadPosition);
				break;
				case "doPause":
					s.Media.stop(_mediaName,_playheadPosition);
				break;
				
				
				
				
				default:
					//make sure we use the default only to the custome events
					for (var o:Object in customEvents)
					{
						if (note.getName() == customEvents[o].toString())
						{
							 sendGeneralNotification(note.getName())
							break;
						}
					}
				break;
				
			}
		}
		/**
		 * Send a general notification. let the code handle the logic 
		 * 
		 */
		private function sendGeneralNotification(evt:String):void
		{
			eventDispatcher.dispatchEvent(new Event(evt));
		}
		
		/**
		 * view component 
		 */		
		public function get view() : DisplayObject
		{
			return viewComponent as DisplayObject;
		}
		
		
		
		// unique 
		
	}
}