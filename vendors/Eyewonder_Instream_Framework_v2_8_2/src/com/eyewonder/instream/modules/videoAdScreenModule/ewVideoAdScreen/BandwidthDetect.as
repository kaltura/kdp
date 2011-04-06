/*
BandWidthDetect.as

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

A class that handles bandwidth detection using a given bandwidth detection file.

*/
package com.eyewonder.instream.modules.videoAdScreenModule.ewVideoAdScreen
{
	import com.eyewonder.instream.modules.videoAdModule.VAST.events.*;
	import com.eyewonder.instream.debugger.*;
	import com.eyewonder.instream.events.UIFEvent;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	import flash.events.IOErrorEvent;
	
/**
* Dispatched when the video screen determines the end-user's bandwidth
*
* @eventType com.eyewonder.events.BandwidthEvent.BW_DETECT
*/
[Event(name="bwDetect", type="com.eyewonder.qaplayer.events.BandwidthEvent")]

	/**
	 * The BandwidthDetect class can be used to detect the current bandwidth
	 * of the end-user's machine. It's used internally for determining the bandwidth
	 * of the video to play.
	 * 
	 * @example <listing version="3.0">var bwDetect:BandwidthDetect = new BandwidthDetect();
	 * bwDetect.addEventListener("bwDetect", myBandwidthListener );
	 * bwDetect.detectBandwidth()
	 * 
	 * function myBandwidthListener( event:BandwidthEvent ):void
	 * {
	 * 		var myBandwidth:int = event.bandwidth;
	 * }
	 * </listing>
	 * 
	 */
	public dynamic class BandwidthDetect extends EventDispatcher
	{
		public var startTime:Number;
		
		public var bandwidth:Number;
		public var _defaultBandwidth:Number;
		public var streamBandwidth:Number;
		public var adMode:String;
		
		public var streamHelper:VideoStreamConnector;
		
		public var bandwidthDetectProgressiveURL:String; // This file should be at least a few hundred KB on a fast, trusted, distributed CDN
		
		
		public function BandwidthDetect(adMode:String, bwDetectProgressiveURL:String)
		{
			this.adMode = adMode;
			streamBandwidth = -1;
			_defaultBandwidth = 300;
			bandwidthDetectProgressiveURL = bwDetectProgressiveURL;
		}
		
		public function bandwidth_Start( event:Event ):void
		{
			startTime = getTimer();
		} 
		
		public function bandwidth_Complete( event:Event ):void
		{
			var loaderInfo:LoaderInfo = (event.target as LoaderInfo);
			var bandwidth:int = bandwidth_Calculate( startTime, loaderInfo.bytesTotal );
			dispatchEvent( new BandwidthEvent( BandwidthEvent.BW_DETECT, bandwidth, streamBandwidth ));
		}
		
		public function bandwidth_Calculate( startTime:int, bytesTotal:int ):int
		{
			var elapsedTime:Number = ( getTimer() - startTime ) / 1000;
			var totalBits:Number = bytesTotal * 8;
			var totalKBits:Number = totalBits / 1024;
			var kbps:Number = (totalKBits / elapsedTime );	
			
			//trace("BandwidthDetect.bandwidth_Calculate(): " + kbps);
			return Math.floor( kbps );
			
		}
		
		public function _detectBandwidth_Progressive():void
		{	
			var bwMovie:MovieClip = new MovieClip();
			bwMovie.height = 0;
			bwMovie.width = 0;
			bwMovie.visible = false;
			
			//trace("BandwidthDetect._detectBandwidth_Progressive(): ");
			
			var bwMovieUri:String = bandwidthDetectProgressiveURL + "?ewbust="+(new Date()).getTime();
			
			var bwLoader:Loader = new Loader();
			
			bwLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			bwLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			bwLoader.contentLoaderInfo.addEventListener(Event.OPEN, bandwidth_Start);
			bwLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, bandwidth_Complete);
			bwMovie.addChild( bwLoader );
			
			try
			{	
				bwLoader.load(new URLRequest( bwMovieUri ));	
			}
			catch(e:Error)
			{
				//UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: " + e.message, "VAST");
				//dispatchEvent(new UIFEvent(UIFEvent.ERROR_EVENT));
				UIFDebugMessage.getInstance()._debugMessage(2, "Request for bandwidth detection file failed. Set default bandwidth to " + _defaultBandwidth +" kb/s", "VAST");
				dispatchEvent( new BandwidthEvent( BandwidthEvent.BW_DETECT, _defaultBandwidth, streamBandwidth ));
			}
			catch(e:IOError)
			{
				//UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: " + e.message, "VAST");
				//dispatchEvent(new UIFEvent(UIFEvent.ERROR_EVENT));
				UIFDebugMessage.getInstance()._debugMessage(2, "Request for bandwidth detection file failed. Set default bandwidth to " + _defaultBandwidth +" kb/s", "VAST");
				dispatchEvent( new BandwidthEvent( BandwidthEvent.BW_DETECT, _defaultBandwidth, streamBandwidth ));
			}
			catch(e:SecurityError)
			{
				//UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: " + e.message, "VAST");
				//dispatchEvent(new UIFEvent(UIFEvent.ERROR_EVENT));
				UIFDebugMessage.getInstance()._debugMessage(2, "Request for bandwidth detection file failed. Set default bandwidth to " + _defaultBandwidth +" kb/s", "VAST");
				dispatchEvent( new BandwidthEvent( BandwidthEvent.BW_DETECT, _defaultBandwidth, streamBandwidth ));
			}
			
		}
		
		public function _detectBandwidth():void
		{
			if( adMode == "FLV Asset" || adMode == "progressive") _detectBandwidth_Progressive();
			if(adMode == "On Demand Stream" || adMode == "Live Stream") _detectBandwidth_Streaming();
		}
		
		public function _detectBandwidth_Streaming():void
		{
			streamHelper = new VideoStreamConnector();
			streamHelper.addEventListener( VideoStreamConnectorEvent.STREAM_CONNECTED, stream_connected);
			streamHelper.addEventListener( BandwidthEvent.BW_DETECT, stream_bw);
		}
		
		public function stream_connected( event:VideoStreamConnectorEvent ):void
		{
			event.stream.close();
		}
		
		public function stream_bw( event:BandwidthEvent ):void
		{
			streamBandwidth = event.bandwidth;
			_detectBandwidth_Progressive();
		}
		
		public function onIOError(e:IOErrorEvent):void
		{
			//UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: " + e.text, "VAST");
			//dispatchEvent(new UIFEvent(UIFEvent.ERROR_EVENT));
			UIFDebugMessage.getInstance()._debugMessage(2, "Request for bandwidth detection file failed. Set default bandwidth to " + _defaultBandwidth +" kb/s", "VAST");
			dispatchEvent( new BandwidthEvent( BandwidthEvent.BW_DETECT, _defaultBandwidth, streamBandwidth ));
		}
		
		public function onSecurityError(e:SecurityErrorEvent):void
		{
			//UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: " + e.text, "VAST");
			//dispatchEvent(new UIFEvent(UIFEvent.ERROR_EVENT));
			UIFDebugMessage.getInstance()._debugMessage(2, "Request for bandwidth detection file failed. Set default bandwidth to " + _defaultBandwidth +" kb/s", "VAST");
			dispatchEvent( new BandwidthEvent( BandwidthEvent.BW_DETECT, _defaultBandwidth, streamBandwidth ));
		}
		
		/**
		 * Begins calculating the end user's bandwidth. Listen to the "bwDetect" event
		 * to determine the bandwidth.
		 */
		public function detectBandwidth():void
		{
			_detectBandwidth();
			
		}
	}
}