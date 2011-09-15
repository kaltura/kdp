/*
VASTClickThru.as

Universal Instream Framework
Copyright (c) 2006-2009, Eyewonder, Inc
All Rights Reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
 * Neither the name of Eyewonder, Inc nor the
 names of contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Eyewonder, Inc ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Eyewonder, Inc BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

This file should be accompanied with supporting documentation and source code.
If you believe you are missing files or information, please 
contact Eyewonder, Inc (http://www.eyewonder.com)



Description
-----------

Handles clickThru for the VAST module.

*/
package com.eyewonder.instream.modules.videoAdModule.VAST.utility {
	import com.eyewonder.instream.debugger.UIFDebugMessage;	
	import com.eyewonder.instream.parser.VastTranslator;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;

	public dynamic class VASTClickThru extends Sprite
	{
		
		public var browserEngine : String = 'unknown';
		public var url:String;
		public var translator : VastTranslator;
		public var VASTClickThru_mc:MovieClip 
		public var cacheBuster:CacheBuster;
		public var trackingURLs:Array = []; /*An array of String that are URLs*/
		
		public function VASTClickThru(cb:CacheBuster, URL:String, trackingURLs:Array = null)
		{
			cacheBuster = cb;
			browserEngine = getBrowserEngine();
			url = URL;
			if(trackingURLs)
				this.trackingURLs = trackingURLs;
		}

		public function onClickThru(e:Event):void
		{
			getURL(cacheBustURL(url), "_blank");
			trackClickThru();	
		}
		
		public function trackClickThru():void
		{	
			UIFDebugMessage.getInstance()._debugMessage(2, "In trackClickThru().", "VAST", "VASTClickThru");
			
			for(var i:int; i < trackingURLs.length; i++)
			{
				var cacheBustedURL:String = cacheBuster.cacheBustURL(String(trackingURLs[i]), CacheBuster.AD);
				var trkRequest:URLRequest = new URLRequest(cacheBustedURL);
	
				var impressionHolder:MovieClip = new MovieClip();
				impressionHolder.requestQueue = new RequestQueue();
				impressionHolder.requestQueue.addRequest(trkRequest);
				UIFDebugMessage.getInstance()._debugMessage(2, "ClickThru tracker: " + cacheBustedURL, "VAST", "VASTClickThru");
			}
		}

		public function getBrowserEngine() : String {
		
			// Get User Agent
			try {
				var userAgent : String = ExternalInterface.call("eval", "navigator.userAgent");
				userAgent = userAgent.toLowerCase();
				var isIe : Boolean = (userAgent.indexOf("msie") >= 0);
				var isOpera : Boolean = (userAgent.indexOf('opera') >= 0);
				if(isOpera) isIe = false;
				var isSafari : Boolean = (userAgent.indexOf('applewebkit') >= 0 || userAgent.indexOf('konqueror') >= 0);
				var isGecko : Boolean = (userAgent.indexOf('gecko/') > 0);
			
				if(isIe) browserEngine = 'msie';
				if(isOpera) browserEngine = 'opera';
				if(isSafari) browserEngine = 'webkit';
				if(isGecko) browserEngine = 'gecko';
			} catch( e : Error ) {
				browserEngine = 'unknown';
			}
			
			return browserEngine;
		}

		public function getURL( url : String, window : String = "_self" ) : void {
			var compatBrowser : Boolean = false;
	
			switch( browserEngine ) {
				case "webkit":
				case "opera":
				case "internabl":
				case "unknown":
				case "aim":
					compatBrowser = false;
					break;
				default:
					compatBrowser = true;
			}
			
			if( window != "_self" && ExternalInterface.available && compatBrowser) {
				ExternalInterface.call("window.open", url, window, "");
			} else { 
				var request : URLRequest = new URLRequest(url);
				flash.net.navigateToURL(request, window);
			}
		}
		
		/* Non-essential code omitted */
		public function cacheBustURL(urlToTag:String):String
		{
			return cacheBuster.cacheBustURL( urlToTag, CacheBuster.AD);
		}		
		
		
	}
}

//MAKE SURE TO REWORK FOR VAST
//IMPORT EXTERNALINTERFACE CLASS
//NEED TO BUILD INTO OUR OWN CLASS OF VASTCLICKTHRU
