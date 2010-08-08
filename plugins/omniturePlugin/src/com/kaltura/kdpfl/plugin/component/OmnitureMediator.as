package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.vo.KalturaPlayableEntry;
	import com.omniture.AppMeasurement;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
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
		private var _mediaIsLoaded:Boolean=false;
		private var _fullScreen:Boolean=false;
		private var _normalScreen:Boolean=false;
		private var _lastSeek:Number=0;
		private var _playheadPosition:Number=0;
		private var _lastId : String = "";
		private var _isNewLoad : Boolean = false;
		private var _mediaName : String;
		private var _duration : Number;
		
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
		
		
		private var s:AppMeasurement;
		
		
		/**
		 * Constructor. 
		 * @param disStats	disable statistics
		 * @param viewComponent	the view component for thsi mediator
		 */		
		public function OmnitureMediator(disStats : Boolean, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			(viewComponent as DisplayObject).addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/**
		 * After all parameters are set - init the AppMeasurement object
		 */
		public function init():void
		{
			var f:Object = Facade.getInstance();
			var cp:Object = Facade.getInstance().retrieveProxy("configProxy");
			s = new AppMeasurement();
			s.account = account;
			s.debugTracking = true;
			s.trackLocal = true;
			s.Media.trackWhilePlaying = true;
			s.pageName = cp.vo.flashvars.referer;
			s.pageURL = cp.vo.flashvars.referer;
			s.charSet = "UTF-8";
			s.currencyCode = "USD";
			s.Media.trackMilestones = trackMilestones;
			s.trackClickMap = true;
			s.Media.playerName= cp.vo.kuiConf.name;
			s.dc = '122';
			s.visitorNamespace = visitorNamespace;
			s.trackingServer = trackingServer;
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
			return  [
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
						"kdpReady",
						"doSeek"
					];
		}
		
				
		private function _perecntStatsChanged(currPosition:Number, duration:int):int
		{
			
			var percent:Number = 0;
			var seekPercent:Number = 0;
			
			if (_inDrag || _inFF)
			{
				return -1;
			}	
			
			if (duration > 0)
			{
				percent = currPosition / duration;
				seekPercent = _lastSeek/duration;
			}

			if (!_p25Once && Math.round(percent*100) >= 25 && seekPercent < 0.25)
			{
				_p25Once = true;
				return 25;
			}
			else if (!_p50Once && Math.round(percent*100) >= 50 && seekPercent < 0.50)
			{
				_p50Once = true;
				return 50;
			}
			else if (!_p75Once && Math.round(percent*100) >= 75 && seekPercent < 0.75)
			{
				_p75Once = true;
				return 75;
			}
			else if (!_p100Once && Math.round(percent*100) >= 98 && seekPercent < 1)
			{
				_p100Once = true;
				return 100;
			}
							
			return -1;
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
					sendGeneralNotification("widgetLoaded");
				break;
				
				case "hasOpenedFullScreen":
				 if(_fullScreen==false)
				 {
					sendGeneralNotification("openFullScreen");
				 }
				_fullScreen=true;
				_normalScreen=false;	
				break;
				case "hasCloseFullScreen":
				if(_normalScreen==false)
				{
					sendGeneralNotification("closeFullScreen");
				}
				_fullScreen=false;
				_normalScreen=true;	
				break;
			
				case "playerPlayed":
					if (_isNewLoad && !_played)
					{
						//kse.eventType = com.kaltura.types.KalturaStatsEventType.PLAY;
						s.Media.play(_mediaName,_playheadPosition);
						_played = true;
					}
				break; 
				case "doDownload":
					sendGeneralNotification("openDownload");
				break; 
				case "doGigya":
					sendGeneralNotification("openViral");
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
				    	}
				    	else
				    	{
				    		_isNewLoad = false;
				    		_lastSeek = 0;
				    	}
				    	_mediaIsLoaded=true;
				    }
					s.movieID = _lastId;
					s.Media.open(_mediaName,media.duration, "somePlayerName");
					sendGeneralNotification("mediaLoaded");
					
					
				break;
							
				case "durationChange":
					if(_isNewLoad){
						_hasSeeked = false;
						_p25Once = false;
						_p50Once = false;
						_p75Once = false;
						_p100Once = false;
					}
					return;
				break;	

				case "fastForward":
					_inFF = true;
					return;
				break;
				
				case "stopFastForward":
					_inFF = false;
					return;				
				break;
				case "playerSeekEnd":
					_inSeek = false;
					return;
				break;
						
				case "scrubberDragStart":
					_inDrag = true;
					sendGeneralNotification("startDragging",_playheadPosition.toString());
					return;
				break;
				 		
				case "scrubberDragEnd":
					_inDrag = false;
					_inSeek = false;
					sendGeneralNotification("endDragging",_lastSeek.toString());
					return;
				break;
								 		
				case "playerUpdatePlayhead":
					_playheadPosition = data as Number;
					var precentageTime:int = _perecntStatsChanged(data as Number, _duration);

				break;
				
				case "kdpReady":
				//Ready should not occur more than once
					if (_ready) return;
					_ready = true;
				break;
				case "doSeek":
					_lastSeek = Number(note.getBody());
					if(_inDrag && !_inSeek)
					{
						sendGeneralNotification("seek",_lastSeek.toString());
					}
					_inSeek = true;
					_hasSeeked = true;
				break;
			}
			
			//if we entery this function for any wrong resone and we don't have event to send, just return...
		}
		/**
		 * Send a general notification with or without an additional param
		 * 
		 */
		private function sendGeneralNotification(str:String, evar:String=""):void
		{
			if(evar)
			{
				s.Media.trackVars = "eVar1,events";
				s.Media.trackEvents = str;
				s.events = str;
				s.eVar1 = evar;
			}
			else
			{
				s.Media.trackVars = "events";
				s.Media.trackEvents =str;
				s.events=str;
			}
			//send and clean
			s.Media.track(_mediaName);
			s.Media.trackVars = null;
			s.Media.trackEvents = null;
			s.eVar1 = null;
			s.events= null;
		}
		
		/**
		 * view component 
		 */		
		public function get view() : DisplayObject
		{
			return viewComponent as DisplayObject;
		}
		
	}
}