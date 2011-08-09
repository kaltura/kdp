/*
VideoAdModule.as

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

Instantiates a VAST Translator to begin playing a VAST ad.

*/
package com.eyewonder.instream.modules.videoAdModule.base
{
	import com.eyewonder.instream.base.InstreamFrameworkBase;
	import com.eyewonder.instream.debugger.*;
	import com.eyewonder.instream.events.UIFEvent;
	import com.eyewonder.instream.events.UIFControlEvent;
	import com.eyewonder.instream.modules.videoAdModule.VAST.utility.*;
	import com.eyewonder.instream.modules.videoAdScreenModule.base.IVideoAdScreenModule;
	import com.eyewonder.instream.modules.videoAdScreenModule.events.ChosenMediaFileEvent;
	import com.eyewonder.instream.parser.VASTParser;
	import com.eyewonder.instream.parser.VastTranslator;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	
	public dynamic class VideoAdModule extends MovieClip implements IVideoAdModule 
	{
		public var _ewad:InstreamFrameworkBase; //instance of uif passed in through constructor
		public var _videoAdScreenModule:IVideoAdScreenModule;		
		
		public var vastParser:VASTParser; //instance of VAST parser passed in through constructor
		public var requestQueue:RequestQueue;//tracks impressions and other tracking events
		
		public var vastClickThru:VASTClickThru; //stores clickThru URL & CacheBuster
		
		public var cacheBuster:CacheBuster;//passed in through constructor and used for impression and tracking events
		
		public var translator:VastTranslator; //vast parser data object
		
		public var checkInitialVolume:Boolean = true;//Change to use player volume settings on creative load.
		public var _qualityFirst:Boolean;
		
		public var _preferredDeliveryMethod:String;//preferred method passed in from uif streaming or progressive 
		
		public var _bwDetectProgressiveURL:String; //url used for detecting progressive bandwidth
		public var _bwDetectStreamingServer:String; //url used for detecting streaming bandwidth
		
		public var trkRequest:URLRequest; //used for tracking 
		
		public var vastWrapperImpression:MovieClip;//created when tracking an impression inside a VAST wrapper tag						
		public var impressionHolder:MovieClip;//created when tracking an impression inside a VAST tag	
		public var vastHolder:MovieClip;
		
		public var pausedNS:Number = -1;
		public var remaining:Number = -1;
		public var total:Number = -1;
		public var TimerInitial:Number = -1;
		public var _audioVolume:Number = -1;// -1 means player didn't set volume
		
		public var _adContainerParentWidth:Number; //stores a reference to uif's adContainerParent_mc width 
		public var _adContainerParentHeight:Number; //stores a reference to uif's adContainerParent_mc height
		public var _adContainerParentX:Number; //stores a reference to uif's adContainerParent_mc x 
		public var _adContainerParentY:Number; //stores a reference to uif's adContainerParent_mc y
		
		public function VideoAdModule(ewad:InstreamFrameworkBase, videoAdScreenModule:IVideoAdScreenModule):void
		{
			_ewad = ewad;
			_videoAdScreenModule = videoAdScreenModule;
			
			vastParser = ewad._vastParser;
			
			cacheBuster = ewad._cacheBuster;			
			
			vastHolder = new MovieClip();
			
			ewad.timerStop();// Stop initial timer since this isn't a preroll format
			
			ewad._adIsPlaying = true;
			
			if(ewad._bandwidth)
			{
				UIFDebugMessage.getInstance()._debugMessage(2, "Using provided UIF bandwidth: " + ewad._bandwidth, "VAST");
				_videoAdScreenModule.setBandWidth(ewad._bandwidth);
			}
						
			_adContainerParentWidth = ewad._videoRect.width;
			_adContainerParentHeight = ewad._videoRect.height;
			_adContainerParentX = ewad._videoRect.x;
			_adContainerParentY = ewad._videoRect.y;
			
			setupUIFListeners();	
			setupAudioListeners();		
			setupVideoScreenListeners();		
			
			//adds the VideoPlayer to the stage
			addChild(videoAdScreenModule.getVideoPlayer());
		}
		
		//public methods
		public function remainingTime(remaining:Number, total:Number):void
		{
			UIFDebugMessage.getInstance()._debugMessage(3, "In remainingTime()", "VAST", "VASTModule");
			ewad.remainingTime(remaining,total);	
		}
		
		//make avaiable to subclasses
		public function playPlayerVideo():void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "In playPlayerVideo()", "VAST", "VASTModule");
			ewad.setVideoState(2);
		}
		
		//make avaiable to subclasses
		public function pausePlayerVideo():void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "In pausePlayerVideo()", "VAST", "VASTModule");
			ewad.setVideoState(3);
		}
		
		public function trackImpression():void
		{
			ewad.trackLoad();

			var i:Number = 0;
			var cacheBustURL:String = "";
			var trkRequest:URLRequest;
			for (i = 0; i < translator.impressionWrapperArray.length; i++) {
				//cache busts vast urls
				cacheBustURL = cacheBuster.cacheBustURL(translator.impressionWrapperArray[i].url, CacheBuster.AD);
				trkRequest = new URLRequest(cacheBustURL);
	
				impressionHolder.trkImpression = new MovieClip();
				impressionHolder.trkImpression.requestQueue = new RequestQueue();
				impressionHolder.trkImpression.requestQueue.addRequest(trkRequest);
				UIFDebugMessage.getInstance()._debugMessage(2, "Wrapper Impression tracker: " + cacheBustURL, "VAST", "VASTModule");
			}
			
			for(i = 0; i < translator.impressionArray.length; i++)
			{
				//cache busts vast urls
				cacheBustURL = cacheBuster.cacheBustURL(translator.impressionArray[i].url, CacheBuster.AD);
				trkRequest = new URLRequest(cacheBustURL);

			impressionHolder.trkImpression = new MovieClip();
			impressionHolder.trkImpression.requestQueue = new RequestQueue();
			impressionHolder.trkImpression.requestQueue.addRequest(trkRequest);
				UIFDebugMessage.getInstance()._debugMessage(2, "Impression tracker: " + cacheBustURL, "VAST", "VASTModule");
			}
			
		}
		
		public function trackError():void
		{
			var i:Number = 0;
			var cacheBustURL:String = "";
			var trkRequest:URLRequest;
			for(i = 0; i < translator.errorWrapperArray.length; i++)
			{
				//cache busts vast urls
				cacheBustURL = cacheBuster.cacheBustURL(translator.errorWrapperArray[i].url, CacheBuster.AD);
				trkRequest = new URLRequest(cacheBustURL);
	
				impressionHolder.trkError = new MovieClip();
				impressionHolder.trkError.requestQueue = new RequestQueue();
				impressionHolder.trkError.requestQueue.addRequest(trkRequest);
				UIFDebugMessage.getInstance()._debugMessage(2, "Wrapper Error tracker: " + cacheBustURL, "VAST", "VASTModule");
			}
			
			for(i = 0; i < translator.errorArray.length; i++)
			{
				//cache busts vast urls
				cacheBustURL = cacheBuster.cacheBustURL(translator.errorArray[i].url, CacheBuster.AD);
				trkRequest = new URLRequest(cacheBustURL);
	
				impressionHolder.trkError = new MovieClip();
				impressionHolder.trkError.requestQueue = new RequestQueue();
				impressionHolder.trkError.requestQueue.addRequest(trkRequest);
				UIFDebugMessage.getInstance()._debugMessage(2, "Error tracker: " + cacheBustURL, "VAST", "VASTModule");
			}
			
		}
		
		public function trackClickThru(event:Event = null):void
		{
			ewad.trackClickthru();

			var i:Number = 0;
			var cacheBustURL:String = "";
			var trkRequest:URLRequest;
			
			for(i = 0; i < translator.clickThruWrapperArray.length; i++)
			{
				//cache busts vast urls
				cacheBustURL = cacheBuster.cacheBustURL(translator.clickThruWrapperArray[i].url, CacheBuster.AD);
				trkRequest = new URLRequest(cacheBustURL);
	
				impressionHolder.trkClickThru = new MovieClip();
				impressionHolder.trkClickThru.requestQueue = new RequestQueue();
				impressionHolder.trkClickThru.requestQueue.addRequest(trkRequest);
				UIFDebugMessage.getInstance()._debugMessage(2, "Wrapper ClickThru tracker: " + cacheBustURL, "VAST", "VASTModule");
			}
			
			for(i = 0; i < translator.clickThruArray.length; i++)
			{
				//cache busts vast urls
				cacheBustURL = cacheBuster.cacheBustURL(translator.clickThruArray[i].url, CacheBuster.AD);
				trkRequest = new URLRequest(cacheBustURL);
	
				impressionHolder.trkClickThru = new MovieClip();
				impressionHolder.trkClickThru.requestQueue = new RequestQueue();
				impressionHolder.trkClickThru.requestQueue.addRequest(trkRequest);
				UIFDebugMessage.getInstance()._debugMessage(2, "ClickThru tracker: " + cacheBustURL, "VAST", "VASTModule");
			}
		}
		
		//set up VAST trackers
		public function trackingEvents(trackingArray:Array, trackingWrapperArray:Array = null):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "In trackingEvents()", "VAST", "VASTModule");
			
			var i:Number = 0;
			
			//set up VAST wrapper trackers
			for (i = 0; i < trackingWrapperArray.length; i++)
			{
				//cache busts wrapper urls
				var cacheBustWrapperURL:String = cacheBuster.cacheBustURL(String(trackingWrapperArray[i].url), CacheBuster.AD);
				var trkWrapperRequest:URLRequest = new URLRequest(cacheBustWrapperURL);
				
				vastWrapperImpression = new MovieClip();
				vastWrapperImpression.requestQueue = new RequestQueue();
				vastWrapperImpression.requestQueue.addRequest(trkWrapperRequest);
				if (cacheBustWrapperURL != null || cacheBustWrapperURL != "undefined")
					UIFDebugMessage.getInstance()._debugMessage(2, "Wrapper Event tracker: " + cacheBustWrapperURL );
			}
			
			for(i = 0; i < trackingArray.length; i++)
			{
				//cache busts vast urls
				var cacheBustURL:String = cacheBuster.cacheBustURL(String(trackingArray[i].url), CacheBuster.AD);
				var trkRequest:URLRequest = new URLRequest(cacheBustURL);
	
				impressionHolder = new MovieClip();
				impressionHolder.requestQueue = new RequestQueue();
				impressionHolder.requestQueue.addRequest(trkRequest);
				UIFDebugMessage.getInstance()._debugMessage(2, "Event tracker: " + cacheBustURL, "VAST", "VASTModule");
			}
		}
		
		//returns current audio volume value from uif
		public function getAudioVolume():Number
		{
			var av:Number = 0;
			av = ewad.audioVolume;
			
			UIFSendToPanel.getInstance()._sendToPanel("[VAST_TMPL] Player audio volume is: " + av);
			
			if (isNaN(av))
			{
				UIFSendToPanel.getInstance()._sendToPanel("[VAST_TMPL] Player volume is NaN. Ignoring.");
				av = -1;
			}
			return av;
		}
		
		//make avaiable to subclasses
		public function onXMLError(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "In onXMLError()", "VAST", "VASTModule");
			end_IS(); //unloads the VAST Module
		}

		//private methods and event handlers
		public function setupUIFListeners():void
		{
			ewad.addEventListener(UIFControlEvent.AD_VOLUME_CHANGED, audioVolumeChanged);
			ewad.addEventListener(UIFControlEvent.ON_RESIZE_NOTIFY, onResizeNotify);		
		}
		
		public function setupAudioListeners():void
		{
			//set adVideo listeners
			UIFSendToPanel.getInstance()._sendToPanel("[VAST_TMPL] set up adVidPlay listener on ");
			ewad.addEventListener(UIFControlEvent.AD_VID_PLAY, adVidPlay);
			UIFSendToPanel.getInstance()._sendToPanel("[VAST_TMPL] set up adVidPause listener on ");
			ewad.addEventListener(UIFControlEvent.AD_VID_PAUSE, adVidPause);
			UIFSendToPanel.getInstance()._sendToPanel("[VAST_TMPL] set up adVidSeek listener on ");
			ewad.addEventListener(UIFControlEvent.AD_VID_SEEK, adVidSeek);
		}
		
		public function setupVideoScreenListeners():void
		{
			videoAdScreenModule.addEventListener("start", onPlayBackStart);
			videoAdScreenModule.addEventListener("stop", onVideoStopped);
			videoAdScreenModule.addEventListener("complete", onEndOfVideo);
			videoAdScreenModule.addEventListener("error", onVideoFailed);
			videoAdScreenModule.addEventListener("mute", onMuteVideo);
			videoAdScreenModule.addEventListener("pause", onPauseVideo);
			videoAdScreenModule.addEventListener("midPoint", onMidOfVideo);
			videoAdScreenModule.addEventListener("firstQuartile", onFirstQuartile);
			videoAdScreenModule.addEventListener("thirdQuartile", onThirdQuartile);
			videoAdScreenModule.addEventListener("mediaFileChosen", onMediaFileChosen);
			videoAdScreenModule.addEventListener("fullscreen", onEnterFullscreen );
			videoAdScreenModule.addEventListener(UIFEvent.ERROR_EVENT, sOnError );
		}
		
		public function removeEventListeners():void {
			UIFSendToPanel.getInstance()._sendToPanel("[VAST_TMPL] removing video ad module listeners");
			
			videoAdScreenModule.removeEventListener("start", onPlayBackStart);
			videoAdScreenModule.removeEventListener("stop", onVideoStopped);
			videoAdScreenModule.removeEventListener("complete", onEndOfVideo);
			videoAdScreenModule.removeEventListener("error", onVideoFailed);
			videoAdScreenModule.removeEventListener("mute", onMuteVideo);
			videoAdScreenModule.removeEventListener("pause", onPauseVideo);
			videoAdScreenModule.removeEventListener("midPoint", onMidOfVideo);
			videoAdScreenModule.removeEventListener("firstQuartile", onFirstQuartile);
			videoAdScreenModule.removeEventListener("thirdQuartile", onThirdQuartile);
			videoAdScreenModule.removeEventListener("mediaFileChosen", onMediaFileChosen);
			videoAdScreenModule.removeEventListener("fullscreen", onEnterFullscreen );
			videoAdScreenModule.removeEventListener(UIFEvent.ERROR_EVENT, sOnError );
			
			ewad.removeEventListener(UIFControlEvent.AD_VID_PLAY,adVidPlay);
			ewad.removeEventListener(UIFControlEvent.AD_VID_PAUSE,adVidPause);
			ewad.removeEventListener(UIFControlEvent.AD_VID_SEEK,adVidSeek);
			ewad.removeEventListener(UIFControlEvent.AD_VOLUME_CHANGED, audioVolumeChanged);
			ewad.removeEventListener(UIFControlEvent.ON_RESIZE_NOTIFY, onResizeNotify);        
		}
		
		public function resizeVideoScreen():Boolean
		{
			var width:Number = ewad._adTagWidth;
			var height:Number = ewad._adTagHeight;
			
			var scale:Boolean = ewad.config.scaleVAST;
			
			if(!scale && width > _adContainerParentWidth)
			{
				return false;
			}
			else if(!scale && height > _adContainerParentHeight)
			{
				return false;
			}
			else
			{
				UIFDebugMessage.getInstance()._debugMessage(2, "In resizeVideoScreen " + width + " : " + height, "VAST", "VASTModule");	
				videoAdScreenModule.resize(width, height, _adContainerParentWidth, _adContainerParentHeight, _adContainerParentX, _adContainerParentY);
				return true;
			}
			
		}
		
		/* Audio volume ================================================ */
		//listening for audio volume change event from uif framework
		public function audioVolumeChanged(e:Event = null):void
		{
			UIFSendToPanel.getInstance()._sendToPanel("[VAST_TMPL] audioVolumeChanged received from player");
			_audioVolume = getAudioVolume();
			setAudioVolume(_audioVolume);
		}

		//updates the video screen with current audio
		public function setAudioVolume(num:Number):void
		{
			if (num == -1)
			{
				UIFSendToPanel.getInstance()._sendToPanel( "[VAST_TMPL] Player didn't set audio volume. Ignoring.");
				return;
			}
			else if (num == -2)
			{
				UIFSendToPanel.getInstance()._sendToPanel("[VAST_TMPL] Creative didn't check audio volume. Ignoring.");
				return;
			}
			
			UIFSendToPanel.getInstance()._sendToPanel("[VAST_TMPL] Setting audio volume to: " + num);
			videoAdScreenModule.setVolume(num);	
			
			if (num == 0)
			{
				dispatchEvent(new Event("mute"));
			}
		}
		
		public function getInitialVolume():void
		{
			UIFSendToPanel.getInstance()._sendToPanel( "[VAST_TMPL] Getting initial player audio volume");
			_audioVolume = getAudioVolume();// This is used later by the child SWF after it loads
			setAudioVolume(_audioVolume);
		}
		
		public function checkInitialVolumeFunction():void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "In checkInitialVolumeFunction()", "VAST", "VASTModule");
			
			if (checkInitialVolume == true)
			{
				getInitialVolume();// Do this before loading holder
			}
		}

		// end_IS is a wrapper for the instream close method is used to completely clear out the ad, including the "Brand exposure time" tracker.
		// Note: Do NOT call this method directly but instead use gotoAndPlay("done") or all pending interaction trackers won't get serviced.
		public function end_IS():void
		{
			UIFSendToPanel.getInstance()._sendToPanel( "[VAST_TMPL] Function end_IS called. Sending endAd to player.");
			cleanUp(); // Clear out all active listeners before going to ewad.endAd()
			ewad.endAd();// Clear out anything actively running. This should be the last thing called and only after events clear out
		}
		
		public function TimerUpdate():void
		{
			if (typeof(ewad.remainingTime) != "undefined")
			{
				remaining =  videoAdScreenModule.getVideoLength()-videoAdScreenModule.getVideoTime();
				total = videoAdScreenModule.getVideoLength();
				remainingTime(remaining, total);
			}
		}
		
		public function TimerCleanup():void
		{
			clearInterval(TimerInitial);
		}

		//listening to uif for resizeNotify then updates the videoScreen
		public function onResizeNotify(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(3, "In onResizeNotify " , "VAST", "VideoAdModule" );
			resizeVideoScreen();
		}



		
		//listening to the videoScreen and setting uif's adTagWidth, adTagHeight, adTagAlignHorizontal, and adTagAlignVertical properties
		public function onMediaFileChosen(e:ChosenMediaFileEvent):void
		{
			UIFDebugMessage.getInstance()._debugMessage(3, "In onMediaFileChosen() " , "VAST", "VideoAdModule" );
			ewad._adTagWidth = e.width;
			ewad._adTagHeight = e.height;
			
			ewad.dispatchUIFEvent( UIFControlEvent.ON_START_LINEAR );
			ewad.dispatchUIFEvent( UIFControlEvent.ON_START_FIXEDROLL );
		}
		
		public function onPlayBackStart(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "0% of Video Reached " , "VAST", "VASTModule" );
			checkInitialVolumeFunction();

			ewad.dispatchUIFEvent( UIFControlEvent.ON_START_PLAY_AD );			
			
			ewad.trackStartOfVideo(); //notifying uif to track start of video
			//updates video screen with correct size
			if(!resizeVideoScreen())
			{
				end_IS();
				videoAdScreenModule.removeVideoScreen();
				// 	playPlayerVideo();
				return;
			}
			//startOfVideo
			if (TimerInitial == -1)
			{
				TimerInitial = setInterval(TimerUpdate,100);
			}
			//tracks start of video events
			trackingEvents(translator.trkStartEvent, translator.trackingStartWrapperArray);
		}
		
		public function onFirstQuartile(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "25% of Video Reached ", "VAST", "VASTModule");	
			ewad.trackFirstQuartileOfVideo();
			//tracks first quartile video events
			trackingEvents(translator.trkFirstQuartileEvent, translator.trackingFirstQuartileWrapperArray);
		}
		
		public function onMidOfVideo(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "50% of Video Reached", "VAST", "VASTModule");		
			ewad.trackMidOfVideo(); //notifying uif to track mid of video			
			//tracks mid of video events
			trackingEvents(translator.trkMidPointEvent, translator.trackingMidPointWrapperArray);
		}
		
		public function onThirdQuartile(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "75% of Video Reached", "VAST", "VASTModule");
			ewad.trackThirdQuartileOfVideo();
			//tracks third quartile video events
			trackingEvents(translator.trkThirdQuartileEvent, translator.trackingThirdQuartileWrapperArray);
		}
		
		public function onEndOfVideo(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "100% of Video Reached", "VAST", "VASTModule");
			
			ewad.trackEndOfVideo(); //notifying uif to track end of video	
						
			//endOfVideo
			TimerCleanup();
			
			//tracks end of video events
			trackingEvents(translator.trkCompleteEvent, translator.trackingCompleteWrapperArray);
			
			end_IS(); //unloads the VAST Module
			//playPlayerVideo(); //restarts the player's video
		}
		
		public function onReplayVideo(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "In onReplayVideo()", "VAST", "VASTModule");
			//tracks replay video events
			trackingEvents(translator.trkReplayEvent, translator.trackingReplayWrapperArray);
		}
		
		public function onEnterFullscreen(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "In onEnterFullscreen()", "VAST", "VASTModule");
			ewad.trackEnterFullscreen(); //notifying uif to track change to fullscreen
			//tracks fullscreen events, enter fullscreen only
			trackingEvents(translator.trkFullScreenEvent, translator.trackingFullScreenWrapperArray);	
		}
		
		public function onVideoStopped(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "In onVideoStopped()", "VAST", "VASTModule");
			//tracks video stopped video events
			trackingEvents(translator.trkStopEvent, translator.trackingStopWrapperArray);
		}
		
		public function onPauseVideo(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "In onPauseVideo()", "VAST", "VASTModule");
			//tracks pause video events
			trackingEvents(translator.trkPauseEvent, translator.trackingPauseWrapperArray);
		}
		
		public function onMuteVideo(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "In onMuteVideo()", "VAST", "VASTModule");
			//tracks mute video events
			trackingEvents(translator.trkMuteEvent, translator.trackingMuteWrapperArray);
		}
		
		public function onVideoFailed(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "In onVideoFailed()", "VAST", "VASTModule");	
			trackError();
			end_IS(); //unloads the VAST Module
			//playPlayerVideo(); //restarts the player's video
		}
		
		public function sOnError( e:Event ):void {
			UIFDebugMessage.getInstance()._debugMessage(2, "In sOnError()", "VAST", "VASTModule");	
			trackError();
			end_IS(); //unloads the VAST Module
		}
		
		//AD VIDEO CONTROL
		// Pauses the player video
		public function adVidPause(e:Event):void
		{
			UIFSendToPanel.getInstance()._sendToPanel("[VAST_TMPL] Pausing Ad video");
			videoAdScreenModule.pause();
			pausedNS = videoAdScreenModule.getVideoTime();
		}

		// Plays the player video
		public function adVidPlay(e:Event):void
		{
			UIFSendToPanel.getInstance()._sendToPanel("[VAST_TMPL] Playing Ad video");
			videoAdScreenModule.play();
		}

		// Seeks the player video in mlliseconds
		public function adVidSeek(e:Event):void
		{
			if (remaining != -1 && total != -1)
			{
				var adVidSeekPosition:Number;
				var adVidSeekOffset:Number;
				if (ewad.eventData.adVidSeekPosition != undefined)
				{
					UIFSendToPanel.getInstance()._sendToPanel("[VAST_TMPL] adVidSeekPosition: " +ewad.eventData.adVidSeekPosition);
					adVidSeekPosition = ewad.eventData.adVidSeekPosition;
					switch (adVidSeekPosition)
					{
						case -2 :
							adVidSeekPosition = videoAdScreenModule.getVideoTime()*1000;//current position of the playhead
							break;
						case -1 :
							adVidSeekPosition = videoAdScreenModule.getVideoLength()*1000;
							break;
						case 0 :
							adVidSeekPosition = 0;//beginning of video
							break;
						default :
							//use defined value
							break;
					}
				}
				if (ewad.eventData.adVidSeekOffset != undefined)
				{
					UIFSendToPanel.getInstance()._sendToPanel("[VAST_TMPL] adVidSeekOffset: " +ewad.eventData.adVidSeekOffset);
					adVidSeekOffset = ewad.eventData.adVidSeekOffset;
				}
				//Sanity checking values passed.
				var seekValue = adVidSeekPosition + adVidSeekOffset;
				if ((seekValue/1000) > videoAdScreenModule.getVideoLength())
				{
					seekValue = videoAdScreenModule.getVideoLength()*1000;
				}
				if ((seekValue/1000) < 0)
				{
					seekValue = 0;
				}
				//Tell video object ot seek to value defined
				var pos = seekValue/1000;
				UIFSendToPanel.getInstance()._sendToPanel("[VAST_TMPL] Seeking Ad video to: " +pos);
				videoAdScreenModule.seek(pos);
			}
		}
		
		public function cleanUp():void
		{
			  UIFDebugMessage.getInstance()._debugMessage(2,"In VideoAdModule:cleanUp() - removing all listeners, resume video.");
			  removeEventListeners();
			  playPlayerVideo();
		}
			
		//EventHandler Cleanup
		//add any and all event handlers here to cleanup and remove on ad shutdown
		public function handlerCleanup(e:Event)
		{
			if (ewad.hasEventListener("audioVolumeChanged"))
				ewad.removeEventListener("audioVolumeChanged", audioVolumeChanged);
		}

		//getters and setters
		public function get ewad():InstreamFrameworkBase
		{
			return _ewad;
		}
		
		public function get videoAdScreenModule():IVideoAdScreenModule
		{
			return _videoAdScreenModule;
		}	
	}
}
