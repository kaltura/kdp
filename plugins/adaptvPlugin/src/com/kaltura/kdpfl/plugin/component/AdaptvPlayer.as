package com.kaltura.kdpfl.plugin.component
{
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.Timer;

	/**
	 * A class which can display ads on top of a video.
	 */
	public class AdaptvPlayer extends Sprite{	
		
		private var adPlayerURL:String = "http://redir.adap.tv/redir/client/AdPlayer.swf";				
		private var loader:Loader = new Loader();
		private var config:Object;
		//private var callback:Object;
		private var setStatusObject:Object;
		private var setStatusTimer:Timer;
		private var isLoaded:Boolean = false;
		private var shouldCallInitialize:Boolean;		
		private var targetWidth:Number = -1;
		private var targetHeight:Number = -1;
		
		//LocalConnections
		private var sendConnection:LocalConnection;
		private var recvConnection:LocalConnection;		
		private var sendConnName:String;
		private var recvConnName:String;
		
		private var isAdPlayerLoaded:Boolean = false;
			 										
		private var tmrSetStatus:Timer;
		private var statusMethod:Function;
				 										
		public function AdaptvPlayer(config:Object, adaptvintegrate:String = undefined):void {	
			Security.allowDomain("*");
			this.config = config;
			//this.callback = callback;
			if (this.config!=null) {
				shouldCallInitialize = true;
			}
			//create localConnection names
			initializeLocalConnections();
			generateConnectionNames();
			//Load adplayer 8 with flashvars
			config.inConnName = sendConnName;
			config.outConnName = recvConnName;			
			adPlayerURL = addParamsToURL(adPlayerURL, {inConnName:sendConnName, outConnName:recvConnName});
			if (adaptvintegrate != null)
			{
				adPlayerURL = addParamsToURL(adPlayerURL, {adaptvintegrate:adaptvintegrate});
			}
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.contentLoaderInfo.addEventListener(Event.INIT, handleAdPlayerLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.contentLoaderInfo.addEventListener(ErrorEvent.ERROR, errorHandler);
			
			//Set up an AdPlayer swf loading timeout
			var adPlayerLoadingTimer:Timer = new Timer(10000, 1);
			adPlayerLoadingTimer.addEventListener(TimerEvent.TIMER_COMPLETE, adPlayerLoadingTimeout);
			adPlayerLoadingTimer.start();
			loader.load(new URLRequest(adPlayerURL));
		}
		private function onComplete(event:Event):void {
//			loader.addEventListener(Event.ADDED_TO_STAGE,onAdded);			
			addChild(loader);
		}	
		
//		private function onAdded(evt:Event):void {
//			/* trace(this.parent.parent.parent);
//			trace(this.parent.parent.parent.width);
//			trace(this.parent.parent.parent.height); */
//			//setSize(targetWidth, targetHeight);
//		}
		
		/**
		 * If the adplayer swf has taken too long to load, cancel Adap.tv loading and play the video
		 * */
		private function adPlayerLoadingTimeout(event:TimerEvent):void {
			if(!isLoaded){
				playVideo();
				this.parent.removeChild(this);
			}
		}
		private function addParamsToURL(baseURL:String, params:Object):String{
			var returnURL:String = baseURL;
			
			var PARAM_SEPARATOR:String;
			if(returnURL.indexOf("?") == -1){
				PARAM_SEPARATOR = "?";
			} else {
				PARAM_SEPARATOR = "&";
			}
			
			for(var param:String in params){
				if(param != null && 
				   params[param] != null &&
				   (typeof(params[param]) != "number" || !isNaN(params[param]))){
					returnURL += PARAM_SEPARATOR;
					returnURL += param;
					returnURL += "=";
					returnURL += escape(params[param]);
					PARAM_SEPARATOR = "&";
				}
			}
			return returnURL;
		}
		
		/**
		 * This is a request to initialize the AdPlayer.
		 */
		public function initialize(config:Object):void {
			this.config = config;
			//this.callback = callback;
			shouldCallInitialize = true;
			sendInitData();
		}
		
		/**
		 * Tries to send locally stored initialize data to the inner AdPlayer.
		 */
		private function sendInitData():void {
			if (isLoaded) {
				try {
					sendConnection.send(sendConnName, "initialize", config, null);	
					shouldCallInitialize = false;
				} catch (error:Error) {
					// do nothing
				}	
			}		
		} 
		
		public function setStatus(o:Object):Object {	
			if (!isLoaded) return null; // throw away the call if we're not loaded
			Security.allowDomain("*");			
			this.setStatusObject = o;
 			return null;
		}
		 
		public function setStatusRateLimiter(event:TimerEvent):void {
			if(shouldCallInitialize) {
				sendInitData();
			}
			sendConnection.send(sendConnName, "setStatus", setStatusObject);	
		}
				
		public function setSize(width:Number, height:Number):void {
/* 			if (!isLoaded){
				//save width and height and pass in once adplayer loaded
				this.targetWidth = width;
				this.targetHeight = height;
				return; 
			} else
			{ 
			} */
			targetWidth = width;
			targetHeight = height;
 			sendConnection.send(sendConnName, "setSize", targetWidth, targetHeight);	
		}	
		
		//helper functions
		
		private function generateRandomString(len:int):String {			
			if(len <= 0) return null;
			var str:String = "_";
			for(var i:int=0; i < len-1; i++){
				var char:String = new String(Math.floor(Math.random() * 10));
				str += char;
			}
			return str;			
		}
		
		private function statusErrorHandler(event:StatusEvent):void {}
		
		private function generateConnectionNames():void{
			Security.allowDomain("*");
			sendConnName = generateRandomString(20);
			recvConnName = generateRandomString(19);
			recvConnection.connect(recvConnName);
			recvConnection.client = this;					
		}
		
		private function handleAdPlayerLoaded(event:Event):void {	
			
			isLoaded = true;
			isAdPlayerLoaded = true;
			trace("adPlayerLoaded");
			setStatusTimer = new Timer(1000);
			setStatusTimer.addEventListener("timer", setStatusRateLimiter);
			setStatusTimer.start();
			
			if(this.targetWidth != -1 || this.targetHeight != -1){
				setSize(targetWidth, targetHeight);
			}
			if(shouldCallInitialize) {
				sendInitData();
			}
		}	
		
		private function initializeLocalConnections():void {
			sendConnection = new LocalConnection();
			recvConnection = new LocalConnection();
			sendConnection.addEventListener(StatusEvent.STATUS, function(event:StatusEvent):void{});
			sendConnection.allowDomain("*");		
			sendConnection.allowInsecureDomain("*");
			recvConnection.addEventListener(StatusEvent.STATUS, function(event:StatusEvent):void{});
			recvConnection.allowDomain("*");
			recvConnection.allowInsecureDomain("*");			
		}
		
		public function startSetStatus(statusMethod:Function):void
		{
			this.statusMethod = statusMethod;

			if (tmrSetStatus && tmrSetStatus.running) tmrSetStatus.stop();
			tmrSetStatus = new Timer(1000, 0);
			tmrSetStatus.addEventListener(TimerEvent.TIMER, onSetStatus);  
			tmrSetStatus.start(); 
		}
		
		public function stopSetStatus():void
		{
			if (tmrSetStatus && tmrSetStatus.running) tmrSetStatus.stop();
		}
		
		private function onSetStatus(event:TimerEvent):void {  
    		this.setStatus(statusMethod());  
		}
		
		//callback functions
		public function pauseVideo():void {
			dispatchEvent( new Event("pauseVideo") );
		}
		
		public function playVideo():void {
			dispatchEvent( new Event("playVideo") );
		}
		
		public function adAvailable(hasAd:Boolean):void {
			// deprecated callback
		}
		
		public function viewCovered():void {
			// deprecated callback
		}

		public function handleAdEvent(event:Object):void {
			// deprecated callback
		}
		
		public function handleVpaidEvent(event:Object):void {
			//callback.handleVpaidEvent(event);
		}

		public function setStatusCallback():void {
			// deprecated callback
		}
		
		
		/**
		 * if any error occured, start playing the video. 
		 * @param event
		 */		
		private function errorHandler(event:Event):void {
			dispatchEvent( new Event("playVideo") );
			isAdPlayerLoaded = true;
		}		
	}		                           
}