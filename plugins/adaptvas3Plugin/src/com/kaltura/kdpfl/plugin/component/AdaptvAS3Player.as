package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.model.type.AdsNotificationTypes;
	import com.kaltura.kdpfl.model.type.NotificationType;
	
	import fl.core.UIComponent;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.Timer;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	/**
	 * A class which can display ads on top of a video.
	 */
	public class AdaptvAS3Player extends UIComponent{	
		
		private static const BREAK_STARTED:String    = 'breakStarted';
		private static const BREAK_ENDED:String      = 'breakEnded';
		private static const SCRIPT_FETCHED:String   = 'scriptFetched';
		private static const CUSTOM:String           = 'custom';
		private static const CLICK_THRU:String       = 'clickThru';
		private static const LINEAR_CHANGED:String   = 'linearChanged';
		private static const COMPANION:String        = 'companion';
		
		
		public static const ADAPTV_PLAY:String        = 'adaptvPlay';
		public static const ADAPTV_PAUSE:String        = 'adaptvPause';
		public static const ADAPTV_STAT:String        = 'adaptvStat';
		public static const ADAPTV_STAT_CLICK:String        = 'adaptvStatClick';
		public static const ADAPTV_ENABLE_CHANGED:String        = 'adaptvEnableChanged'; 
		public static const ADAPTV_RESUME:String        = 'adaptvResume'; 
		
		public static const ADAPTV_ADMANAGER_LOADED:String = "adaptvAdmanagerLoaded";
		public static const ADAPTV_ADMANAGER_LOAD_FAILED:String = "adaptvAdmanagerLoadFailed";
		//Holds loaded AdPlayer
		private var adPlayer:*;
		private var volume:Number= -1;
		
		private var _adPlayerURL:String = "http://redir.adap.tv/redir/client/static/AS3AdPlayer.swf";				
		private var loader:Loader = new Loader();
		private var config:Object;
		//private var callback:Object;
		private var setStatusObject:Object;
		private var setStatusTimer:Timer;
		private var targetWidth:Number = -1;
		private var targetHeight:Number = -1;
		private var _shouldEnable:Boolean;
		
		private	var _tmrContentPlayheadChanged:Timer;
		public var playheadPosition:Number = 0;    
		public var facade:IFacade;    
		public var context:Object;    
		
		//LocalConnections
		private var sendConnection:LocalConnection;
		private var recvConnection:LocalConnection;		
		private var sendConnName:String;
		private var recvConnName:String;
		
		private var _isAdPlayerLoaded:Boolean = false;
		
		
		public function get shouldEneble():Boolean
		{
			return _shouldEnable;
		}
		
		private var statusMethod:Function;
		
		public function AdaptvAS3Player():void 
		{	
			Security.allowDomain("*");
			//Load the AdPlayer: 
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, handleAdPlayerLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.contentLoaderInfo.addEventListener(ErrorEvent.ERROR, errorHandler);
			loader.load(new URLRequest(_adPlayerURL));
			//addChild(loader);
			_tmrContentPlayheadChanged = new Timer(800, 0);
			_tmrContentPlayheadChanged.addEventListener(TimerEvent.TIMER, onContentPlayheadChanged);  
		}	
		
		
		private function onContentPlayheadChanged(event:TimerEvent):void 
		{ 
			//Get playhead position in seconds
			var seconds:Number = playheadPosition ; // replace with player method for getting playhead time in seconds
			adPlayer.contentPlayheadChanged(seconds);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void 
		{
			//go through Facade
			//facade.sendNotification("sequenceItemPlayEnd");
			dispatchEvent( new Event (ADAPTV_ADMANAGER_LOAD_FAILED, true) );
		}
		
		
		
		
		public function buildConfig(o:Object):void
		{
			config = o;
			// context is a parameter used for passing custom keys to the ad player.
			if (context)
				config.context = context;
			
			if(adPlayer)
			{
				configRaceCondition();
			}
		}
		
		
		public function endOfClip():void
		{
			adPlayer.contentEnded();
			adPlayer.startBreak();
		}
		
		public function fetchScript():void
		{
			if (adPlayer)
			{
				adPlayer.fetchScript();
			} else 
			{
			}
		}
		
		
		//helper functions
		private function generateRandomString(len:int):String 
		{			
			if(len <= 0) return null;
			var str:String = "_";
			for(var i:int=0; i < len-1; i++){
				var char:String = new String(Math.floor(Math.random() * 10));
				str += char;
			}
			return str;			
		}
		
		private function statusErrorHandler(event:StatusEvent):void 
		{
		}
		
		private function handleAdPlayerLoaded(event:Event):void 
		{	
			this.dispatchEvent( new Event (ADAPTV_ADMANAGER_LOADED,true ) );
			_isAdPlayerLoaded = true;
			
			var loaderInfo:LoaderInfo = LoaderInfo(event.target);
			adPlayer = loaderInfo.content;
			addChild(adPlayer);
			
			loader.contentLoaderInfo.removeEventListener(Event.INIT, handleAdPlayerLoaded);
			adPlayer.addEventListener(SCRIPT_FETCHED, onScriptFetched);
			adPlayer.addEventListener(BREAK_STARTED, onBreakStarted);
			adPlayer.addEventListener(BREAK_ENDED, onBreakEnded);
			adPlayer.addEventListener(CUSTOM, onCustom);
			adPlayer.addEventListener(CLICK_THRU, onClickThru);
			adPlayer.addEventListener(LINEAR_CHANGED, onLinearChanged);
			adPlayer.addEventListener(COMPANION, onCompanion);

			//Default API Version of 2.1, can be changed at start with apiVersion(version)
			adPlayer.apiVersion('2.1');
			// replace "playerFrame" with variable holding the playerFrame size and position
			adPlayer.setContentSize(200, 200, false);
			
			adPlayer.x = 0;
			adPlayer.y = 0;
			
			//Required if HTML integrated:
			/*			adPlayer.setHTMLSize(playerFrame.width, playerFrame.height, playerFrame.x, playerFrame.y);
			*/
			//adPlayer.setContentSize(this.width, this.height, false);
			//initialize()
			_tmrContentPlayheadChanged.start(); 
			
			if(config)
			{
				configRaceCondition();
			}

		}	
		
		private function configRaceCondition():void
		{
			
			if (config && adPlayer)
			{
				if (width && height)
				{
					adPlayer.setContentSize(width, height, false);
				}
				adPlayer.setMetadata(config);
			}
		}
		
		
		
		/**
		 * if any error occured, start playing the video. 
		 * @param event
		 */		
		private function errorHandler(event:Event):void 
		{
			dispatchEvent( new Event("playVideo") );
			_isAdPlayerLoaded = true;
		}	
		
		
		public function get adPlayerURL():String
		{
			return _adPlayerURL;
		}
		
		public function set adPlayerURL(value:String):void
		{
			_adPlayerURL = value;
		}
		
		
		//Ad script fetched:
		public function onScriptFetched(evt:Object):void 
		{
			// To inform that an ad break is available call:
			if(volume > -1)
				adPlayer.setVolume(volume);
			adPlayer.startBreak();
		}
		
		//Linear ad break started:
		public function onBreakStarted(evt:Object):void 
		{
			// The player should be paused and controls disabled
			if(volume > -1)
				adPlayer.setVolume(volume);
			enableControllers(false);
			pauseVideo();
			sendStat();
			//facade.sendNotification(AdsNotificationTypes.AD_START);
		}
		
		//Linear ad break ended:
		public function onBreakEnded(evt:Object):void 
		{
			// The player can now play and controls should be enabled
			enableControllers(true);
			playVideo();  
			// To inform that the clip is playing and available for overlay call:
			adPlayer.contentStarted();
			//facade.sendNotification(AdsNotificationTypes.AD_END);
		}
		
		//Custom ad plugin message:
		public function onCustom(evt:Object):void 
		{
			// Process the custom data sent in the event object, evt
		}
		
		//Ad click through event:
		public function onClickThru(evt:Object):void 
		{
			dispatchEvent(new Event(ADAPTV_STAT_CLICK));
			
		}
		//Volume change
		public function setVolume(value:Number):void 
		{
			if (adPlayer) 
				adPlayer.setVolume(value);
			volume = value;
		}
		
		public function onLinearChanged(evt:Object):void {
			
			if (evt.data.linear == true) {
				enableControllers(false);
				pauseVideo();
			}
			else {
				enableControllers(true);
				resumeVideo();
			}

		}

		
		//Ad companion information event:
		public function onCompanion(evt:Object):void 
		{
			// The following information is available:
			// * evt.data.companion_creative_type: "any", "JPEG", "GIF", "PNG", "SWF", "other", "image/jpeg", "image/gif", "image/png", "application/x-shockwave-flash"
			// * evt.data.companion_width: [Number]
			// * evt.data.companion_height: [Number]
			// * evt.data.companion_display_data: depending on the ad format, either the URL of the asset or the HTML/Javascript snippet;
			// * evt.data.companion_resource_type: "iframe", "script", "HTML", "static", "other"
			// * evt.data.companion_click_thru: [url String]
			// * evt.data.player_handles: [Boolean true if the companion is handled by the ad player, as opposed to the external ad unit]
		}
		
		
		
		private function playVideo():void
		{
			dispatchEvent(new Event(ADAPTV_PLAY));
		}
		private function sendStat():void
		{
			dispatchEvent(new Event(ADAPTV_STAT));
		}
		private function pauseVideo():void
		{
			dispatchEvent(new Event(ADAPTV_PAUSE));
		}
		private function resumeVideo():void
		{
			dispatchEvent(new Event(ADAPTV_RESUME));
		}
		
		
		
		
		
		private function enableControllers(value:Boolean):void
		{
			_shouldEnable = value;
			dispatchEvent(new Event(ADAPTV_ENABLE_CHANGED));
		}
		
		override public function set width(value:Number):void
		{
			if (adPlayer)
			{
				adPlayer.setContentSize(value, this.height, false);
			}
			super.width = value;

		}
		override public function set height(value:Number):void
		{
			if (adPlayer)
			{
				adPlayer.setContentSize(this.width, value, false);
			}
			super.height = value;

		}
	}		                           
}