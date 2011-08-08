package com.kaltura.kdpfl.plugin.component
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.system.Security;
	import flash.utils.Timer;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class PlymediaMediator extends Mediator
	{
		public static const NAME:String = "plymediaMediator";
		public static const DEFAULT_HOST:String = "www.kaltura.com";
		private var pageString:String; 
		private var checkSubtitlesPage:String;
		//private static const PAGE_STRING:String = '/extservices/plymedia?movie=entry_';
		//private static const CHECK_SUBTITLES_PAGE:String = "http://content.plymedia.com/initialize?video=";//http://www.kaltura.com/extservices/plymedia?movie=entry_";	
	
		private var _plyClip:Object;		
		private var _view:Sprite;	
		private var _flashvars:Object;	
		
		private var _myTimer:Timer = null;	
		private var _playhead:Number = 0;
		private var _currentEntry:String = "";
		private var _style:String;
		public var menuVisible : Boolean;
		public var languagesArr:Array = new Array();

		public var plySkin:String;
		public var subtitlesButtonVisible:Boolean;
		private static var _curLanguageIndex:int = 0;
		private var _firstCondition:Boolean = false;
		
		public var partner:String = "Kaltura";
		
		/**
		 *  
		 * @param isMenuVisible if we should display the plymedia menu
		 * @param languageOptions a string represantation for languages should be in a valid Plymedia language codes, 
		 * such as "eng" for English, "spa" for Spanish etc. should be seperated by commas
		 * @param showSubsOnStart determines wether to display subtitles immidiately or no language at the begining
		 * @param viewComponent
		 * 
		 */		
		public function PlymediaMediator(isMenuVisible:Boolean, languageOptions:String,  showSubsOnStart:Boolean, useHost:Boolean, viewComponent:Object=null)
		{
			Security.allowDomain("http://content.plymedia.com/");	
			super(NAME, viewComponent);
			_view = viewComponent as Sprite;
			menuVisible = isMenuVisible;
			if (languageOptions) {
				languagesArr = languageOptions.split(",");
			}
			//adds to the languages list the option not to have subtitles at all
			languagesArr.push("OFF");
			if (!showSubsOnStart) {
				//sets index to the "Off" language
				_curLanguageIndex = languagesArr.length - 1;
			}
			
			var host:String;
			if (useHost)
				host = facade.retrieveProxy("configProxy")["vo"]["flashvars"]["host"];
			else
				host = DEFAULT_HOST;
			
			pageString =  facade.retrieveProxy("configProxy")["vo"]["flashvars"]["httpProtocol"]  + host + '/extservices/plymedia?movie=entry_';
			checkSubtitlesPage  = "http://content.plymedia.com/initialize?video=" + pageString;
		}
		
		override public function listNotificationInterests():Array
		{
			return  [
						"playerReady",
						"playerUpdatePlayhead",						
						"playerPlayed",
						"mediaReady",
						"durationChange",
						"kdpReady",
						"kdpEmpty",
						"showSubtitles"
					];
		}
		

		override public function onRegister( ):void 
		{
			setupPLY();
		}	
					
		override public function handleNotification(note:INotification):void
		{
			var kc: Object =  facade.retrieveProxy("servicesProxy")["kalturaClient"];
			var media : Object = facade.retrieveProxy("mediaProxy");
			var entry:String = media["vo"]["entry"]["id"];
			var data:Object = note.getBody();

			switch(note.getName())
			{
				case "playerUpdatePlayhead":
				_playhead = data as Number;
				startTimer();				
				break;
				
				case "playerReady":
				case "mediaReady":
					_currentEntry = entry;
					getPlymediaInfoRequest();
					if (_plyClip) 
						_plyClip.setByVideoPath(setPlymediaUrl());
					break;
				case "durationChange":
				_currentEntry = entry;
				getPlymediaInfoRequest();
				if (_plyClip) {
					//sets current displayed language to the default language
					var currentLanguage:int = (_curLanguageIndex - 1);
					if (currentLanguage<0)
						currentLanguage += languagesArr.length;
					Object(_plyClip).setDefaultSubLang(languagesArr[currentLanguage]);
					_plyClip.setByVideoPath(setPlymediaUrl());
				}
				break;	
				
				case "kdpReady":
				case "kdpEmpty":
					setMenuVisibility();
					//indicates that at least one condition for setMenuVisibility exists
					_firstCondition = true;
				break;	
				
				case "showSubtitles":
					if(_plyClip) 
					{
						//display the subtitles in the next language in the array, or no 
						//subtitles in "OFF" case
						Object(_plyClip).playSubtitlesByLang(languagesArr[_curLanguageIndex]);
						_curLanguageIndex = (_curLanguageIndex + 1) % languagesArr.length;
					}	
				break;
			}
		}
		
		public function get view() : DisplayObject
		{
			return viewComponent as DisplayObject;
		}
		
		/**
		 * sets the plymedia menu visibility according to the given value, and only
		 * if plyClip was loaded AND notification of either kdpReady or kdpEmpty was sent
		 * */
		private function setMenuVisibility() : void
		{
			if (_firstCondition) 
				Object(_plyClip).setUIVisibility(menuVisible);
		}

		private function setupPLY():void 
		{
			//trace('setupPLY]');
			var plyURL:String =	"http://content.plymedia.com/players/"+partner+"/PlyViewer";
			var plyLoader:Loader = new Loader();
			plyLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPlyLoaded);
			plyLoader.load(new URLRequest(plyURL));
		}	
			
		private function onPlyLoaded(event:Event) :void
		{
			//trace('onPlyLoaded] '+event);
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			
			(viewComponent as Plymedia).plymedia = loaderInfo.content;
			//parent.PLY.addChild(loaderInfo.content);
			_plyClip = loaderInfo.content;
			Object(_plyClip).setDefaultSubLang(languagesArr[_curLanguageIndex]);
			//update curLanguageIndex for next change of subtitles
			_curLanguageIndex = (_curLanguageIndex + 1) % languagesArr.length;
			Object(_plyClip).setByVideoPath(setPlymediaUrl());
//			Object(_plyClip).setSubtitlesPosition(50);
//			Object(_plyClip).resize(435,334);
			Object(_plyClip).resize((viewComponent as DisplayObject).parent.parent.width,(viewComponent as DisplayObject).parent.parent.height);
			
			//setting the skin if it was defined 
			if(plySkin)
				setPlymediaSkin(plySkin);
				
			setMenuVisibility();
			_firstCondition = true;
				
		}	

		// timer tic - update plymedia player 	
		private function startTimer():void
		{
			if (_myTimer)
			{
				return;	
			}
			
			_myTimer = new Timer(250,0);
			_myTimer.addEventListener(TimerEvent.TIMER,onTimer);
			_myTimer.start();
		}
		
		private function onTimer(event:TimerEvent):void
		{
			if (_plyClip != null) {
				_plyClip.updateTime(_playhead);
			}
		}
		
		private function setPlymediaUrl():String
		{
			//var config: Object = facade.retrieveProxy("configProxy");
			//var pagePrefix:String = config["vo"]["flashvars"]["httpProtocol"] + config["vo"]["flashvars"]["host"];
			if (_currentEntry != "")
			{
				return  (pageString  + _currentEntry);
			}
			else
			{
				var media : Object = facade.retrieveProxy("mediaProxy");
				var entry:String = media["vo"]["entry"]["id"];
				return  (pageString + entry);
				
			}
		}

		/**
		 * sends url request to plymedia, that should return info on _currentEntry
		 * */
		private function getPlymediaInfoRequest():void {
			//var config: Object = facade.retrieveProxy("configProxy");
			//var pagePrefix:String = CHECK_SUBTITLES_PAGE + config["vo"]["flashvars"]["httpProtocol"] + config["vo"]["flashvars"]["host"];
			if (_currentEntry != "") {
				var req:URLRequest = new URLRequest(checkSubtitlesPage + _currentEntry);
				req.method = URLRequestMethod.GET;		
				var urlLoader: URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, onLoadComplete);
				urlLoader.load(req);
			}
		}
		
		/**
		 * Parses response from plymedia. Check if response contains data inside "subtitles" node and sets subtitlesButtonVisible
		 * value respectively.
		 * */
		private function onLoadComplete(event:Event):void {
			var responseLoader:URLLoader = event.target as URLLoader;
			var xml:XML = XML(responseLoader.data);
			//entry has plymedia subtitles
			if (xml && xml.hasOwnProperty("Content") && xml.Content.hasOwnProperty("Subtitles") && xml.Content.Subtitles.hasOwnProperty("Content")) 
				subtitlesButtonVisible = true;
			else
				subtitlesButtonVisible = false;
				
			_view.dispatchEvent(new Event("subtitlesButtonChange"));
		}
		
		// insert the plymedia key dynamically via JS
		private function registerExternalIntercace():void
		{
			if(ExternalInterface.available)
			{
				ExternalInterface.addCallback("plymediaInsertUrl", changePlymediaUrl);
			}
		}
		
		//change the value of the url of plyMedia player and the player content
		private function changePlymediaUrl(value:String):void
		{
			var kshow:String="-1";
			var entry:String="-1";
			
			//figure out if this is a kshow or an entry
			if(value.split("kshow_").length>1)
			{
				kshow = String(value.split("kshow_")[1]);
			}
			
			if(value.split("entry_").length>1)
			{
				//this is a kshow
				entry = String(value.split("entry_")[1]);
			}
			
			var o:Object = new Object();
		   	o.kshowid = kshow;
		   	o.entryid = entry;
		   	o.entryversion = "-1";
		   	o.autoplay = false;
	   		//load a new kshow or entry
		   	if(entry != "-1" || kshow != "-1" )
		   	{
		   		facade.sendNotification("changeMedia", o);
		   	}
//		   	setSkin();
			if (_plyClip)
				_plyClip.setByVideoPath(setPlymediaUrl());
		}

	
		public function setScreenSize( width:Number, height:Number) : void  
		{
			// Call when video player window changes size (example fullscreen)
			if(_plyClip)
			{
				_plyClip.resize(width, height);
			}
		}
		public function setPlymediaSkin( value:String) : void  
		{
			if (value)
				_style = value;
			// set the plymedia UI definition 
			if(_plyClip)
			{
				try
				{
					if (value!="")
					_plyClip.setSkin(value);
				}
				catch(e:Error)
				{
					trace('Error in setting skin');
				}
			}
		}
	}
}