/*
VideoPlayer.as

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

A VideoPlayer class for the Universal Instream Framework

*/
package com.eyewonder.instream.modules.videoAdScreenModule.ewVideoAdScreen
{
	import com.eyewonder.instream.debugger.*;
	import com.eyewonder.instream.events.*;
	import com.eyewonder.instream.modules.videoAdModule.VAST.events.*;
	import com.eyewonder.instream.modules.videoAdModule.VAST.utility.*;
	import com.eyewonder.instream.modules.videoAdScreenModule.events.ChosenMediaFileEvent;

	import flash.display.MovieClip;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.utils.setTimeout;

	/**
	 * <p>VideoPlayer, also known as the Simple Video Player control, is used to play small/short FLVs (less than 100 KB), external FLVs (not in AdWonder),
	 * and streaming from an Akamai On Demand or Live Streaming account. Most customers would want to use the standard VideoScreen control, which has better metrics
	 * (such as percent of video viewed tracking), automatic bandwidth and format detection (6 different bandwidths, and 3 different video formats), and better integration
	 * into the AdWonder platform. If you wish to use your own FLV, please contact your EyeWonder represenative and ask about the Simple Video Player.</p>
	 *
	 * <p>For the most part, its API compatible with VideoScreen</p>
	 */
	public dynamic class VideoPlayer extends MovieClip
	{
		public var _initialized:Boolean = false;
		public var doPlayVideo:Boolean = false;
		public var connectSuccess:Boolean = false;
		public var streamHelper:VideoStreamConnector;

		public var connectStream:NetConnection;
		public var connectProgressive:NetConnection;
		public var _cachedConnection:NetConnection;

		public var _subscribed:Boolean;

		public var trackThreshold:int;

		// Internal Variables
		public var _playbackStartCalled:Boolean = false;
		public var _isBufferEmpty:Boolean;
		public var _isBufferFlushed:Boolean;
		public var _midOfVideoEventCalled : Boolean = false;
		public var _firstQuartile:Boolean = false;
		public var _thirdQuartile:Boolean = false;
		public var _isStopped:Boolean;
		public var _isPlaying:Boolean;
		public var _isPaused:Boolean;
		public var isMuted:Boolean;
		/** Bandwidth of the video */
        public var _bandwidth : int = -1;
        public var buffer : int;
		public var _stream:NetStream;

		public var bandwidthDetectProgressiveURL:String;  // This file should be at least a few hundred KB on a fast, trusted, distributed CDN
		public var bandwidthDetectStreamingServer:String;
		public var progressiveArray:Array = new Array();
		public var streamingArray:Array = new Array();
		public var closestProgressive:Object = null;
        public var closestStreaming:Object = null;
        public var _qualityFirst:Boolean = true;	// Whether to prefer quality or preferred delivery mode if the highest bandwidth is non-preferred delivery mode
		public var videoFormat:String;	// Streaming video format
		public var selectedDeliveryMethod:String;

		/**
		 * The type of video that VideoPlayer will play.
		 *
		 * <ul>
		 * <li><strong>FLV Asset:</strong> Used for video files added as additional assets of the ad</li>
		 * <li><strong>External FLV:</strong> Used for video files hosted via HTTP elsewhere</li>
		 * <li><strong>On Demand Stream:</strong> Used for playing a video from an Akamai-hosted On Demand Stream</li>
		 * <li><strong>Live Stream:</strong> Used for playing a video from an Akamai-hosted Live Stream</li>
		 * </ul>
		 */
		//[Inspectable (defaultValue="FLV Asset",enumeration="FLV Asset,External FLV,On Demand Stream,Live Stream")]
		public var _preferredDeliveryMethod:String;

		/** The Akamai server the "On Demand Stream" or "Live Stream" is hosted at */
		[Inspectable]
		//public var akamaiServer:String;

		/** The name of the stream to play. For FLV Assets, this should be the file name. For External FLVs, this should be the full URL. For Streams,
		 * this should be the stream name you'd normally pass to NetStream.play().
		 */
		[Inspectable]
		public var _streamName:String;

		public var _videoLength:Number;
		public var _videoLengthManual:Boolean;
		public var video:Video;
		public var videoUrl:String;
		public var applicationName:String;
		public var streamingVideoPath:String;
		public var streamingServer:String;
		public var port:Number;

		public var _ewAdVideoScreen:EWVideoAdScreenModule;

		/**
		* Creates an instance of a VideoPlayer. Preferred method is via drag-and-drop.
		*/
		public function VideoPlayer(ewAdVideoScreen:EWVideoAdScreenModule)
		{
			_initialized = false;
			doPlayVideo = false;
			_isBufferEmpty = false;
			_isBufferFlushed = false;
			_videoLengthManual = false;

			_ewAdVideoScreen = ewAdVideoScreen;
		}

		public function initialize() : void
		{
			if(_initialized) return;

			_initialized = true;

			_qualityFirst = ewAdVideoScreen.getQualityFirst();
			_preferredDeliveryMethod = ewAdVideoScreen.getPreferredDeliveryMethod();
			bandwidthDetectProgressiveURL = ewAdVideoScreen.getBwDetectProgressiveURL();
			bandwidthDetectStreamingServer = ewAdVideoScreen.getBwDetectStreamingServer();
			//stores progressive and streaming media file URLs in arrays
			setupURIArrays();

			RunLoop.addFunction( monitorVideoPlayback );

			// There's a chicken-and-egg problem with Bandwidth detect. We don't know what server to use for BW detect until we know what
			// mediafile to use. But we don't know the mediafile until we detect bandwidth. For now, use the publishers's bandwidth
			// detect. In the future, possibly just use first streaming mediafile (and in AS3, could also request part of the video if only progressive exists)
			if( _bandwidth == -1 )
			{
                var bwDetect:BandwidthDetect = new BandwidthDetect("progressive", bandwidthDetectProgressiveURL);
                bwDetect.addEventListener(BandwidthEvent.BW_DETECT, bandwidth_Callback);
                bwDetect.addEventListener("sOnError", onSOnError);
                bwDetect.detectBandwidth();
			}
			else
			{
				setupFileURI();
				//setup netconnection
				initNetConnection();
				playVideo();
			}
		}

		public function stripVideoURLComponents(): void
		{
			//parses streaming URLs to retrieve the server and application names
			UIFDebugMessage.getInstance()._debugMessage(3, "In stripVideoURLComponents()", "VAST", "VideoPlayer");


			if (videoUrl.lastIndexOf("?") != -1)
				videoUrl = videoUrl.substr(0,videoUrl.lastIndexOf("?"));	// Strip off query string for streaming (note allowed)
			videoUrl = unescape(videoUrl);									// Unescape
			var parseResults:Object = parseURL(videoUrl);

			streamingServer = parseResults.serverName;
			applicationName = parseResults.appName;
			streamingVideoPath = parseResults.streamName;

			port = parseResults.portNumber;
			if (isNaN(port))
			{
				port = 1935;
				UIFDebugMessage.getInstance()._debugMessage(2, "Defaulting to port: " + port, "VAST", "VideoPlayer");
			}
			videoFormat = "";
			if (videoUrl.lastIndexOf(".") != -1)
			{
				videoFormat = videoUrl.substring(videoUrl.lastIndexOf(".")+1);
			}


			UIFDebugMessage.getInstance()._debugMessage(2, "videoFormat: " + videoFormat, "VAST", "VideoPlayer");
			UIFDebugMessage.getInstance()._debugMessage(2, "streamingServer: " + streamingServer + " applicationName: " + applicationName + " streamingVideoPath: " + streamingVideoPath + " port: "+ port, "VAST", "VideoPlayer");
		}

		public function parseURL(url:String):Object
		{
			var parseResults:Object = {};

			// get protocol
			var startIndex:Number = 0;
			var endIndex:Number = url.indexOf(":/", startIndex);
			if (endIndex >= 0) {
				endIndex += 2;
				parseResults.protocol = url.slice(startIndex, endIndex);
				parseResults.isRelative = false;
			} else {
				parseResults.isRelative = true;
			}

			if ( parseResults.protocol != undefined &&
			     ( parseResults.protocol == "rtmp:/" ||
			       parseResults.protocol == "rtmpt:/" ||
			       parseResults.protocol == "rtmps:/" ||
			       parseResults.protocol == "rtmpe:/" ||
			       parseResults.protocol == "rtmpte:/" ) ) {
				parseResults.isRTMP = true;

				startIndex = endIndex;

				if (url.charAt(startIndex) == '/') {
					startIndex++;
					// get server (and maybe port)
					var colonIndex:Number = url.indexOf(":", startIndex);
					var slashIndex:Number = url.indexOf("/", startIndex);
					if (slashIndex < 0) {
						if (colonIndex < 0) {
							parseResults.serverName = url.slice(startIndex);
						} else {
							endIndex = colonIndex;
							parseResults.portNumber = url.slice(startIndex, endIndex);
							startIndex = endIndex + 1;
							parseResults.serverName = url.slice(startIndex);
						}
						return parseResults;
					}
					if (colonIndex >= 0 && colonIndex < slashIndex) {
						endIndex = colonIndex;
						parseResults.serverName = url.slice(startIndex, endIndex);
						startIndex = endIndex + 1;
						endIndex = slashIndex;
						parseResults.portNumber = url.slice(startIndex, endIndex);
					} else {
						endIndex = slashIndex;
						parseResults.serverName = url.slice(startIndex, endIndex);
					}
					startIndex = endIndex + 1;
				}

				// handle wrapped RTMP servers bit recursively, if it is there
				if (url.charAt(startIndex) == '?') {
					var subURL = url.slice(startIndex + 1);
					var subParseResults = parseURL(subURL);
					if (subParseResults.protocol == undefined || !subParseResults.isRTMP) {
						return null;
					}
					parseResults.wrappedURL = "?";
					parseResults.wrappedURL += subParseResults.protocol;
					if (subParseResults.serverName != undefined) {
						parseResults.wrappedURL += "/";
						parseResults.wrappedURL +=  subParseResults.serverName;
					}
					if (subParseResults.wrappedURL != undefined) {
						parseResults.wrappedURL += "/?";
						parseResults.wrappedURL +=  subParseResults.wrappedURL;
					}
					parseResults.appName = subParseResults.appName;
					parseResults.streamName = subParseResults.streamName;
					return parseResults;
				}

				// get application name
				endIndex = url.indexOf("/", startIndex);
				if (endIndex < 0) {
					parseResults.appName = url.slice(startIndex);
					return parseResults;
				}
				parseResults.appName = url.slice(startIndex, endIndex);
				startIndex = endIndex + 1;

				// check for instance name to be added to application name
				endIndex = url.indexOf("/", startIndex);
				if (endIndex < 0) {
					parseResults.streamName = url.slice(startIndex);
					// strip off .flv if included
					if (parseResults.streamName.slice(-4).toLowerCase() == ".flv") {
						parseResults.streamName = parseResults.streamName.slice(0, -4);
					}
					return parseResults;
				}
				parseResults.appName += "/";
				parseResults.appName += url.slice(startIndex, endIndex);
				startIndex = endIndex + 1;

				// get flv name
				parseResults.streamName = url.slice(startIndex);
				// strip off .flv if included
				if (parseResults.streamName.slice(-4).toLowerCase() == ".flv") {
					parseResults.streamName = parseResults.streamName.slice(0, -4);
				}

			} else {
				// is http, just return the full url received as streamName
				parseResults.isRTMP = false;
				parseResults.streamName = url;
			}
			return parseResults;
		}

		public function initNetConnection():void
		{
			connectSuccess = false;

			UIFDebugMessage.getInstance()._debugMessage(3, "In initNetConnection("+streamingServer+")", "VAST", "VideoPlayer");

			if( selectedDeliveryMethod == "streaming" || selectedDeliveryMethod == "Live Stream" )
			{

				streamHelper = new VideoStreamConnector(streamingServer,applicationName,port);
				streamHelper.addEventListener("sOnError", onSOnError);
				streamHelper.addEventListener( VideoStreamConnectorEvent.STREAM_CONNECTED,stream_complete);
				//if(bandwidth == -1) streamHelper.addEventListener(BandwidthEvent.BW_DETECT, bandwidth_Callback);
			}
			else if (selectedDeliveryMethod == "progressive")
			{
				connectProgressive = new NetConnection("progressive");
				connectProgressive.connect( null );
				setupStream( connectProgressive );
			}
		}

		public function stream_complete( event:VideoStreamConnectorEvent ):void
		{
			UIFDebugMessage.getInstance()._debugMessage(3, "In stream_complete()", "VAST", "VideoPlayer");
			connectStream = event.stream;
			setupStream( connectStream );
		}

		public function setupStream( connection:NetConnection ):void
		{
			//creates a new netstream and video object
			UIFDebugMessage.getInstance()._debugMessage(3, "In setupStream()", "VAST", "VideoPlayer");
			if(!_subscribed && selectedDeliveryMethod == "Live Stream")
			{
				_cachedConnection = connection;
				connection.call("FCSubscribe",null,_streamName);
				connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSOnError);
				connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onSOnError);
				connection.addEventListener(IOErrorEvent.IO_ERROR, onSOnError);
				connection.addEventListener(NetStatusEvent.NET_STATUS, stream_status);
				return;
			}

			if( _stream == null )
			{
				if( _stream ) _stream = null;
				_stream = new NetStream( connection );
				_stream.client = this;
				_stream.addEventListener(NetStatusEvent.NET_STATUS, stream_status);
				this.addEventListener(NetStatusEvent.NET_STATUS, dummy);
				_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
				_stream.addEventListener(IOErrorEvent.IO_ERROR, onIOError);

				video = new Video();
				video.smoothing = true;
				addChild(video);

				_playbackStartCalled = false;
				this["video"].attachNetStream( _stream );

			} else {
				_cachedConnection = connection;
			}
		}

		public function dummy( e:NetStatusEvent ):void {

		}

		public function bandwidth_Callback( event : BandwidthEvent ) : void
        {
			UIFDebugMessage.getInstance()._debugMessage(3, "In bandwidth_Callback()", "VAST", "VideoPlayer");

            bandwidth = event.bandwidth;
            dispatchEvent(new BandwidthEvent(BandwidthEvent.BW_DETECT, bandwidth));
            //Finds the appropriate video Mediafile based on bandwidth amount and preferred delivery method
			setupFileURI();
			//setup netconnection
			initNetConnection();
			playVideo();
        }

		public function setupBuffer() : void
        {
			UIFDebugMessage.getInstance()._debugMessage(3, "In setupBuffer()", "VAST", "VideoPlayer");
            if( _bandwidth < 56 ) _bandwidth = 56;

            var tempBandwidth : Number = _bandwidth;

            var bwArray:Array = new Array("56","90","135","300","450","600");
            var bufArray:Array = new Array("5","4","3","2","2","2");

            for( var i : int = 0;i < bwArray.length; i++)
            {
                var bwVar : Number = Number(bwArray[i]);
                if( bwVar <= _bandwidth )
                {
                    tempBandwidth = bwVar;
                    buffer = Number(bufArray[i]);
                }
            }

            _bandwidth = tempBandwidth;

            UIFDebugMessage.getInstance()._debugMessage(2, "Bandwidth Used: " + _bandwidth, "VAST", "VideoPlayer")
        }

        public function mediafileBitrateCompare(A:Object, B:Object)
        {
        	if ( A == null || A.bitrate == null)
        		return 1;  // Move invalid objects to end of Array
        	if ( B == null || B.bitrate == null)
        		return -1; // Move invalid objects to end of Array
        	if (Number(B.bitrate) > Number(A.bitrate))
	        	return 1;
	        else if (Number(A.bitrate) == Number(B.bitrate))
	        	return 0;
	        else return -1;
        }

        public function setupURIArrays():void
        {
        	UIFDebugMessage.getInstance()._debugMessage(3, "In setupURIArrays() ", "VAST", "VideoPlayer");

        	ewAdVideoScreen.getMediaFile().sort(this.mediafileBitrateCompare);

        	for (var i:int = 0; i < ewAdVideoScreen.getMediaFile().length; i++)
        	{
        		if (ewAdVideoScreen.getMediaFile()[i].delivery == "progressive")
        			progressiveArray[progressiveArray.length] = ewAdVideoScreen.getMediaFile()[i];
        		else if (ewAdVideoScreen.getMediaFile()[i].delivery == "streaming")
        			streamingArray[streamingArray.length] = ewAdVideoScreen.getMediaFile()[i];
        	}
        }

        public function setupFileURI():void
        {
         	UIFDebugMessage.getInstance()._debugMessage(3, "In setupFileURI()", "VAST", "VideoPlayer");

       	    var chosen:Object = null;
			closestStreaming = null;
			closestProgressive = null;

        	// Find highest each of non-preferred and preferred method (less than bandwidth)
        	//trace("Printing progressive array");

       		for (var i:int = 0; i < progressiveArray.length; i++)
       		{

       			if (closestProgressive == null )
       			{
       				if (Number(progressiveArray[i].bitrate) <= _bandwidth || (i == progressiveArray.length - 1) /* Default to lowest bandwidth */)
       				{
       					closestProgressive = progressiveArray[i];
       					break;	// Uncomment if not expecting to trace entire array
					}
       			}

        	}
			//trace("Printing streaming array");
       		for (var k:int = 0; k < streamingArray.length; k++)
       		{
       			//trace("VideoPlayer.setupURIArrays() streaming: " + streamingArray[k].bitrate);
       			if (closestStreaming == null )
       			{
       				if (Number(streamingArray[k].bitrate) <= _bandwidth || (i == streamingArray.length - 1) /* Default to lowest bandwidth */)
					{
       					closestStreaming = streamingArray[k];
       					break;	// Uncomment if not expecting to trace entire array
					}
       			}
        	}

     		if (closestStreaming != null)
     			UIFDebugMessage.getInstance()._debugMessage(3, "Closest streaming: " + closestStreaming.bitrate + " " + closestStreaming.url, "VAST", "VideoPlayer");

        	if (closestProgressive != null)
        		UIFDebugMessage.getInstance()._debugMessage(3, "Closest progressive: " + closestProgressive.bitrate + " " + closestProgressive.url, "VAST", "VideoPlayer");

        	if (closestProgressive == null)
        	{
        		if (closestStreaming != null)
        			chosen = closestStreaming;
        			//trace("VideoPlayer.setupFileURI() streaming url: " )
        	}
        	else if (closestStreaming == null)
        	{
        		if (closestProgressive != null)
        			chosen = closestProgressive;
        			//trace("VideoPlayer.setupFileURI() progressive url: " )
        	}
        	else
        	{
	        	if (_qualityFirst == true) // Go with highest quality
	        	{
	        		UIFDebugMessage.getInstance()._debugMessage(3, "Quality is more important than preferred video mode, acting accordingly", "VAST", "VideoPlayer");

	        		if (closestProgressive.bitrate == closestStreaming.bitrate)
	        		{
	        			// NOTE: The following will need to change if a new delivery method is created someday
	        			chosen = (_preferredDeliveryMethod=="progressive")?closestProgressive:closestStreaming;
	        		}
	        		else if (closestProgressive.bitrate > closestStreaming.bitrate)
	        			chosen =closestProgressive;
	        		else
	        			chosen = closestStreaming;
	        	}else // Go with delivery method first
	        	{
        			UIFDebugMessage.getInstance()._debugMessage(3,"Preferred video mode is most important than quality. Acting accordingly", "VAST", "VideoPlayer");

        			// NOTE: The following line will need to change if a new delivery method is created someday
        			chosen = (_preferredDeliveryMethod=="progressive")?closestProgressive:closestStreaming;
	        	}
        	}
			selectedDeliveryMethod = null;

        	if (chosen != null)
        	{
        		UIFDebugMessage.getInstance()._debugMessage(2, "Chosen URL: " + chosen.delivery+ " "  + chosen.bitrate + " " + chosen.url, "VAST", "VideoPlayer");

	        	if(chosen.delivery == "streaming")
	        	{
					selectedDeliveryMethod = "streaming";
					videoUrl = chosen.url;
	        		stripVideoURLComponents();
	        	}
	        	else if (chosen.delivery == "progressive")
	        	{
					selectedDeliveryMethod = "progressive";
	        		videoUrl = chosen.url;
	        	}

	        	dispatchEvent(new ChosenMediaFileEvent("mediaFileChosen", chosen.width, chosen.height));
	        	UIFDebugMessage.getInstance()._debugMessage(2, "chosen mediafile! " + chosen.width + " : " + chosen.height, "VAST", "VideoPlayer");
			}

			if (selectedDeliveryMethod == null)
			{
				// TODO: Add code here to return an error so player doesn't stall
				UIFDebugMessage.getInstance()._debugMessage(2, "No chosen mediafile!", "VAST", "VideoPlayer");
        		dispatchUIFEvent(UIFEvent.ERROR_EVENT);
				return;
			}
        }

		public function onMetaData( infoObject:Object ):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "In onMetaData " , "VAST", "VideoPlayer");
			var width:Number = ewAdVideoScreen.getWidth();
			var height:Number = ewAdVideoScreen.getHeight();

			if(isNaN(width) || width == 0)
			{
				if(isNaN(infoObject.width) || Number(infoObject.width) == 0)
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "In onMetaData: Vast tag width and meta data width isNaN ", "VAST", "VideoPlayer");
					dispatchUIFEvent(UIFEvent.ERROR_EVENT);
				}
				else
				{
					width = infoObject.width;
				}
			}
			if(isNaN(height) || height == 0)
			{
				if(isNaN(infoObject.height) || Number(infoObject.height) == 0)
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "In onMetaData: Vast tag height and meta data height isNaN ", "VAST", "VideoPlayer");
					dispatchUIFEvent(UIFEvent.ERROR_EVENT);
				}
				else
				{
					height = infoObject.height;
				}
			}

			var adContainerParentWidth:Number = ewAdVideoScreen.getAdContainerParentWidth();
			var adContainerParentHeight:Number = ewAdVideoScreen.getAdContainerParentHeight();
			var adContainerParentX:Number = ewAdVideoScreen.getAdContainerParentX();
			var adContainerParentY:Number = ewAdVideoScreen.getAdContainerParentY();

			var scaleVideo:Boolean = ewAdVideoScreen.getScaleVideo();
			var positionVideo:Boolean = ewAdVideoScreen.getPositionVideo()

			UIFDebugMessage.getInstance()._debugMessage(2, "In onMetaData " + "width: " + width + " : " + "height: "+ height, "VAST", "VideoPlayer");
			resizeVideoScreen(width, height, adContainerParentWidth, adContainerParentHeight, adContainerParentX, adContainerParentY, scaleVideo,positionVideo);

			var duration:Number = ewAdVideoScreen.getDuration();

			if(isNaN(duration) || duration == 0)
			{
				if(isNaN(infoObject.duration) || Number(infoObject.duration) == 0)
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "In onMetaData: Vast tag duration and meta data duration isNaN ", "VAST", "VideoPlayer");
					dispatchUIFEvent(UIFEvent.ERROR_EVENT);
				}
				else
				{
					duration = infoObject.duration * 1000;
				}
			}

			UIFDebugMessage.getInstance()._debugMessage(2, "In onMetaData " + "duration: " + infoObject.duration * 1000+ " : " + ewAdVideoScreen.getDuration() , "VAST", "VideoPlayer");
			var _videoLength:Number = (duration / 1000);

			if( _videoLength > 1 && _videoLength < 86400 )
			{

				this.videoLength = _videoLength;
				this.videoLength = Math.floor(videoLength / .1) * .1;
			}
		}

		public function onSOnError(e:Event):void
		{
			dispatchUIFEvent(UIFEvent.ERROR_EVENT);
			dispatchEvent( new UIFEvent( UIFEvent.ERROR_EVENT) );
		}

		public function onIOError(e:IOErrorEvent):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: " + e.text, "VAST", "VideoPlayer");
			dispatchUIFEvent(UIFEvent.ERROR_EVENT);
		}

		public function onAsyncError(e:AsyncErrorEvent):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: " + e.text, "VAST");
			dispatchUIFEvent(UIFEvent.ERROR_EVENT);
		}

		public function monitorVideoPlayback():void
		{
			//monitors video playback and dispatches tracking events
			var percentViewed:Number = ( time/ videoLength ) * 100;
			if(percentViewed >= trackThreshold)
			{
				trackVideoPercentage(trackThreshold);
				trackThreshold += 20;
			}

			if( !isNaN(videoLength) && videoLength > 0 )
			{
				if(!isNaN(percentViewed) && percentViewed >= 25 &&  _firstQuartile == false)
				{
					 _firstQuartile = true;
					 dispatchEvent(new Event("firstQuartile"));
				}

				if(!isNaN(percentViewed) && percentViewed >= 50 &&  _midOfVideoEventCalled == false)
				{
					 _midOfVideoEventCalled = true;
					 dispatchEvent(new Event("midOfVideo"));
				}

				if(!isNaN(percentViewed) && percentViewed >= 75 &&  _thirdQuartile == false)
				{
					 _thirdQuartile = true;
					 dispatchEvent(new Event("thirdQuartile"));
				}

				if( !isNaN(percentViewed) && percentViewed >= 100 && trackThreshold > 100)
				{

					trackVideoPercentage(trackThreshold);
					trackThreshold += 20;
					stopVideo();
					dispatchEvent(new Event("endOfVideo"));
				}
			}
		}

		public function stream_status( event:NetStatusEvent ):void
		{
			var code:String = event.info["code"];
			//trace("stream_status: " + code);

			var ns_isStopped:Boolean;

			switch ( code ) {
				case "NetStream.Play.Start":
					isStopped = false;
					ns_isStopped = false;
					isPlaying = true;
					//dispatchEvent( new Event("playbackStart") );
					if(!_playbackStartCalled)
					{
						  _playbackStartCalled = true;
						  dispatchEvent( new Event("playbackStart") );
						  dispatchUIFEvent(UIFControlEvent.ON_START_PLAY_AD);
					}
					break;

				case "NetStream.Buffer.Full":
					_isBufferEmpty = false;
					_isBufferFlushed = false;
					dispatchEvent( new Event("bufferFull") );
					break;
				case "NetStream.Buffer.Empty":
					_isBufferEmpty = true;
					dispatchEvent( new Event("bufferEmpty") );
					break;
				case "NetStream.Buffer.Flush":
					_isBufferFlushed = true;
					break;
				case "NetStream.Play.Stop":
					ns_isStopped = true;
					dispatchEvent( new Event("playbackStop") );
					break;
				case "NetStream.Play.StreamNotFound":
					dispatchEvent( new Event("videoNotFound") );
					break;

				case "NetStream.Fail":
				case "NetStream.Play.Failed":
					dispatchEvent( new Event("streamFail") );
					break;
				case "NetStream.Play.InsufficientBW":
					dispatchEvent( new Event("streamFail") );
					break;
			}

			if(_isBufferEmpty && _isBufferFlushed && ns_isStopped && trackThreshold <= 100)
			{
				trackVideoPercentage(trackThreshold);
				trackThreshold += 20;
				stopVideo();
				//dispatchEvent( new Event("endOfVideo") );
			}
			dispatchEvent(event);
		}

		/**
		 * Plays the video specified in streamName
		 *
		 * @param videoIndex:int You should ignore this parameter. It's present for API compatibility with VideoScreen.
		 */
		public function playVideo( videoIndex:int = -1):void
		{
			var fileUrl:String;

			if( _stream == null )
			{
				//trace("_stream  not ready");
				setTimeout(playVideo,500);
				return;
			}

			//determine what video to play
			if (selectedDeliveryMethod == "streaming" ||  selectedDeliveryMethod == "Live Stream")
				fileUrl = streamingVideoPath;
			else if (selectedDeliveryMethod == "progressive")
				fileUrl = videoUrl;
			else
			{
				// TODO: assert an error here so the player knows to continue
				UIFDebugMessage.getInstance()._debugMessage(2, "Error: No delivery method! Please verify the VAST URLs provided", "VAST", "VideoPlayer");
				dispatchUIFEvent(UIFEvent.ERROR_EVENT);
				return;
			}

			if( bandwidth == -1 )
			{
				this.videoIndex = videoIndex;
				return;
			}

			if( isPaused )
			{
				_stream.resume();
				isPaused = false;
				isPlaying = true;
			} else {
				if(!isPlaying)
				{
					var start:int = 0;
					if(selectedDeliveryMethod == "Live Stream") start = -1;
					var prepend:String = "";
					if (selectedDeliveryMethod == "streaming" || selectedDeliveryMethod == "Live Stream") {
						if (videoFormat == "flv") {
							prepend = videoFormat + ":";
						} else if(videoFormat == "smil" ) {
							prepend = videoFormat + ":";
						} else {
							UIFDebugMessage.getInstance()._debugMessage(2, "videoFormat not provided, defaulting to mp4!", "VAST", "VideoPlayer");
							prepend = "mp4:";
						}
					}

						try
						{
							_stream.play( prepend + fileUrl,start);
							trace("PREPEND + FILEURL "+prepend + fileUrl);
						}
						catch(e:Error)
						{
							UIFDebugMessage.getInstance()._debugMessage(2, "NetStream Play Error " + e.message, "VAST", "VideoPlayer");
							dispatchUIFEvent(UIFEvent.ERROR_EVENT);
						}
						catch(e:SecurityError)
						{
							UIFDebugMessage.getInstance()._debugMessage(2, "NetStream Play Error " + e.message, "VAST", "VideoPlayer");
							dispatchUIFEvent(UIFEvent.ERROR_EVENT);
						}
						catch(e:ArgumentError)
						{
							UIFDebugMessage.getInstance()._debugMessage(2, "NetStream Play Error " + e.message, "VAST", "VideoPlayer");
							dispatchUIFEvent(UIFEvent.ERROR_EVENT);
						}


					isPlaying = true;
				}
			}
		}

		/** Turns the audio on */
		public function audioOn():void
		{
			volume = 100;
		}

		/** Turns the audio off */
		public function audioOff():void
		{
			volume = 0;
		}

		/**
		 * Fast forwards through the video
		 * @param seconds:Number The number of seconds to fast forward through the video
		 */
		public function forward(seconds : Number) : void
		{
			seek(time + seconds);
		}

		/** Clears the underlying Video object */
		public function clear():void
		{
			video.clear();
		}

		/** Pauses the video */
		public function pauseVideo() : void
		{
			isPaused = true;
			isPlaying = false;
			_stream.pause();
			dispatchEvent(new Event("pause"));
		}

		/**
		 * Stops the currently playing video.
		 *
		 * @param doClear:Boolean Whether or not to clear the video as well.
		 */
		public function stopVideo(doClear : Boolean = false) : void
		{
			if( isStopped ) return;
			if(_stream != null ) _stream.close();
			if( doClear ) clear();
			isPaused = false;
			isPlaying = false;
			isStopped = true;
			dispatchEvent( new Event( PlaybackStateEvent.PLAYBACK_STOP ) );
		}

		/**
		 * Replays the video from the beginning.
		 *
		 * @param turnAudioOn:Boolean Turns the audio on as well.
		 */
		public function replayVideo(turnAudioOn : Boolean = true) : void
		{
			if( turnAudioOn ) audioOn();
			if( selectedDeliveryMethod == "Live Stream" ) return;
			if(isPlaying) seek(0);
			else stopVideo();
			playVideo();
			dispatchEvent(new Event("replay"));
		}

		/**
		 * Rewinds the video
		 * @param seconds:Number The number of seconds to rewind the video
		 */
		public function rewind(seconds : Number) : void
		{
			seek(time - seconds);
		}

		/** Toggles the audio's muted state */
		public function audioToggle():void
		{
			if( isMuted ) audioOn();
			else audioOff();
		}

		/** Toggles the video playback state */
		public function videoToggle() : void
		{
			if(!isPlaying) playVideo();
			else pauseVideo();
		}

		public function getProperty(propertyName : String) : * {
			return this[propertyName];
		}

		public function setProperty(propertyName : String, value : *) : void {
		}

		/** Seeks the underlying stream to the specified point in time. */
		public function seek(offset : Number) : void
		{
			_stream.seek(offset);
		}

		public function resizeVideoScreen(width:Number, height:Number, adContainerParentWidth:Number, adContainerParentHeight:Number, adContainerParentX:Number, adContainerParentY:Number, scaleVideo:Boolean = true, positionVideo:Boolean = true):void
		{
		    UIFDebugMessage.getInstance()._debugMessage(2, "In adContainerParent [" + adContainerParentWidth + " x " + adContainerParentHeight+"]", "VAST", "VideoPlayer");
		    UIFDebugMessage.getInstance()._debugMessage(2, "In adContainerParent (" + adContainerParentY + " , " + adContainerParentX + ")", "VAST", "VideoPlayer");
		    UIFDebugMessage.getInstance()._debugMessage(2, "In Video [" + width + " x " + height+"]", "VAST", "VideoPlayer");

		    var tmpWidth:Number;
		    var tmpHeight:Number;
		    var tmpX:Number;
		    var tmpY:Number;

		    if(scaleVideo)
			{
		    	//SCALE ME
			    if(width/adContainerParentWidth >= height/adContainerParentHeight)
			    {
					tmpWidth = adContainerParentWidth;
					tmpHeight = adContainerParentWidth*height/width;
		    		UIFDebugMessage.getInstance()._debugMessage(2, "Constrain height", "VAST", "VideoPlayer");
			    }else{
					tmpWidth = adContainerParentHeight*width/height;
					tmpHeight = adContainerParentHeight;
		    		UIFDebugMessage.getInstance()._debugMessage(2, "Constrain Width", "VAST", "VideoPlayer");
			    }
			    UIFDebugMessage.getInstance()._debugMessage(2, "In resizeVideoScreen Scale [" + tmpWidth + " x " + tmpHeight+"]", "VAST", "VideoPlayer");
			}else{
				//NO SCALE ME
			    tmpWidth = width;
		    	tmpHeight = height;
			}

		    if(positionVideo)
		    {
		    	//POSITION ME
		    	tmpY = (adContainerParentHeight - tmpHeight)/2;
		    	tmpX = (adContainerParentWidth - tmpWidth)/2 ;
		    	UIFDebugMessage.getInstance()._debugMessage(2, "In resizeVideoScreen Position (" + tmpX + " , " + tmpY+")", "VAST", "VideoPlayer");
		    }else{
		    	//NO POSITION ME
		    	tmpY = adContainerParentY;
		    	tmpX = adContainerParentX;
		    }

		    video.width = tmpWidth;
		    video.height = tmpHeight;
		    video.y = tmpY;
		    video.x = tmpX;
		}

		public function removeVideoScreen():void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "In removeVideoScreen", "VAST", "VideoPlayer");

			stopVideo(true);

			connectStream = null;
			connectProgressive = null;
			_cachedConnection = null;
			_stream = null;
			this.removeChild(video);
			video = null;
		}

		/** Tracks a video interaction on the current video */
		public function trackVideoInteraction(command:String):void
		{

		}

		public function trackVideoPercentage(percent:Number):void
		{

		}

		public function dispatchUIFEvent(name:String, info:Object = null):void
		{
			dispatchEvent(new UIFEvent(name, info));
		}

		public function get ewAdVideoScreen():EWVideoAdScreenModule
		{
			return _ewAdVideoScreen;
		}

		/** Returns the time in the stream */
		public function get time():Number
		{
			if(!_stream) return 0;
			return _stream.time;
		}

		public function get volume():int
		{
			if( _stream == null ) return 0;
			else return _stream.soundTransform.volume * 100;
		}

		/**
		 * Gets/Sets the volume of the VideoScreen from a value 1 to 100
		 *
		 */
		public function set volume( value:int ):void
		{
			var soundTransform:SoundTransform = new SoundTransform();
			soundTransform.volume = (value / 100 );
			if( _stream != null ) _stream.soundTransform = soundTransform;

			// Audio State has been changed
			if( value == 0 ) isMuted = true;
			else isMuted = false;

			dispatchEvent( new AudioStateEvent("audioState", isMuted, value) );
		}

		public function playbackChange_dispatch():void
		{
			dispatchEvent( new PlaybackStateEvent("playbackState", isStopped, isPaused, isPlaying) );
		}

		/** @private */
		public function set isStopped( value:Boolean ):void
		{
			_isStopped = value;

			if( value )
			{
				_isPaused = false;
				_isPlaying = false;
			}

			playbackChange_dispatch();
		}

		/** Returns whether or not a video is stopped */
		public function get isStopped():Boolean
		{
			return _isStopped;
		}

		/** @private */
		public function set isPaused( value:Boolean ):void
		{
			_isPaused = value;

			if( value )
			{
				_isStopped = false;
				_isPlaying = false;
			}
			playbackChange_dispatch();
		}


		/** Returns whether or not a video is paused */
		public function get isPaused():Boolean
		{
			return _isPaused;
		}

		/** @private */
		public function set isPlaying( value:Boolean ):void
		{
			_isPlaying = value;

			if( value )
			{
				_isPaused = false;
				_isStopped = false;
			}

			playbackChange_dispatch();
		}

		CONFIG::isSDK45 {
			/** Returns whether or not a video is playing */
			public function get isPlaying():Boolean
			{
				return _isPlaying;
			}
		}


		CONFIG::isSDK46 {


			override public function get isPlaying():Boolean
			{
				return _isPlaying;
			}
		}


		/**
		 * Length of the video. You can override this if the FLV metadata is corrupt.
		 * For a properly encoded FLV (for instance, using the Adobe Media Encoder), this should be populated automatically from the FLV metadata.
		 */
		public function set videoLength(value:Number):void
		{
			_videoLength = value;
			_videoLengthManual = true;
		}

		/** @private */
		public function get videoLength():Number
		{
			return _videoLength;
		}

		public function set streamName(value:String):void
		{
			_streamName = value;
		}

		/** @private */
		public function set preferredDeliveryMethod(value:String):void
		{
			_preferredDeliveryMethod = value;
		}

		public function set bandwidth( value:int ):void
		{
			_bandwidth = value;
			setupBuffer();
		}

		public function set qualityFirst(value:Boolean):void
		{
			_qualityFirst = value;
		}

		public function get bandwidth():int
		{
			return _bandwidth;
		}
	}
}
