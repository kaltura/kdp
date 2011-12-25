/*
EWVideoAdScreenModule.as

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

A class that tracks many events dispatched by the ad video and videoplayer.
Extends MovieClip and implements IVideoAdScreenModule.as

*/
package com.eyewonder.instream.modules.videoAdScreenModule.ewVideoAdScreen
{
	import com.eyewonder.instream.debugger.*;
	import com.eyewonder.instream.modules.videoAdScreenModule.base.IVideoAdScreenModule;
	import com.eyewonder.instream.modules.videoAdScreenModule.events.ChosenMediaFileEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	public dynamic class EWVideoAdScreenModule extends Sprite implements IVideoAdScreenModule
	{
		public static const FIRST_QUARTILE:String = "firstQuartile";
		public static const MID_POINT:String = "midPoint";
		public static const THIRD_QUARTILE:String = "thirdQuartile";
		public static const COMPLETE:String = "complete";
		public static const ERROR:String = "error";
		public static const STOP:String = "stop";
		public static const START:String = "start";
		public static const MUTE:String = "mute";
		public static const PAUSE:String = "pause";
		
		public var _mediaFile:Array;
		public var _volume:Number;
		public var _duration:Number;
		public var _errorID:Number;
		public var _errorDescription:String;
		public var _bwDetectProgressiveURL:String;
		public var _bwDetectStreamingServer:String;
		public var _defaultBandwidth:Number = 300;
		public var _qualityFirst:Boolean;
		public var _preferredDeliveryMethod:String;
		public var _scaleVideo:Boolean;
		public var _positionVideo:Boolean;
		public var _adContainerParentWidth:Number;
		public var _adContainerParentHeight:Number;
		public var _adContainerParentX:Number;
		public var _adContainerParentY:Number;
		public var _width:Number;
		public var _height:Number;
		public var _videoPlayer:VideoPlayer;
		
		public var _stopInterval:Number = -1;
		public var _stopCheckTime:Number = 0;
		
		public function EWVideoAdScreenModule()
		{
			_videoPlayer = new VideoPlayer(this);
			_videoPlayer.addEventListener("playbackStart", onPlayBackStart);
			_videoPlayer.addEventListener("firstQuartile", onFirstQuartile);
			_videoPlayer.addEventListener("midOfVideo", onMidOfVideo);
			_videoPlayer.addEventListener("thirdQuartile", onThirdQuartile);
			_videoPlayer.addEventListener("endOfVideo", onEndOfVideo);
			_videoPlayer.addEventListener("replayVideo", onReplayVideo);
			_videoPlayer.addEventListener("playbackStop", onVideoStopped);
			_videoPlayer.addEventListener("mute", onMuteVideo);
			_videoPlayer.addEventListener("pause", onPauseVideo);
			_videoPlayer.addEventListener("streamFail", onVideoFailed);
			_videoPlayer.addEventListener("videoNotFound", onVideoFailed);
			_videoPlayer.addEventListener("videoNotFound", onVideoFailed);
			_videoPlayer.addEventListener("sOnError", onVideoFailed);
			_videoPlayer.addEventListener("mediaFileChosen", onMediaFileChosen);
		}
		
		//public methods
		public function initialize():void
		{
			UIFDebugMessage.getInstance()._debugMessage(3,"In EWVideoAdScreenModule(). " , "VAST", "EWVideoAdScreenModule"  );
			_videoPlayer.initialize();
		}

		// Pauses the player video
		public function pause():void
		{
			UIFSendToPanel.getInstance()._sendToPanel("[VAST_TMPL] Pausing Ad video");
			_videoPlayer.pauseVideo();
		}

		// Plays the player video
		public function play():void
		{
			UIFSendToPanel.getInstance()._sendToPanel("[VAST_TMPL] Playing Ad video");
			_videoPlayer.playVideo();
		}

		// Seeks the player video in mlliseconds
		public function seek(pos:Number):void
		{
			_videoPlayer.seek(pos);
		}
		
		//stops the video player
		public function stop():void
		{
			_videoPlayer.stopVideo(true);
		}
		
		public function cleanUp():void {
			UIFDebugMessage.getInstance()._debugMessage(2,"In EWVideoAdModule:cleanUp() - removing VAST video-screen");
			removeVideoScreen();
		}		
		
		public function removeVideoScreen():void
		{
			UIFSendToPanel.getInstance()._sendToPanel("[VAST_TMPL] removing video screen listeners");
			if (_videoPlayer == null) return;
			_videoPlayer.removeVideoScreen();
			
			_videoPlayer.removeEventListener("playbackStart", onPlayBackStart);
			_videoPlayer.removeEventListener("firstQuartile", onFirstQuartile);
			_videoPlayer.removeEventListener("midOfVideo", onMidOfVideo);
			_videoPlayer.removeEventListener("thirdQuartile", onThirdQuartile);
			_videoPlayer.removeEventListener("endOfVideo", onEndOfVideo);
			_videoPlayer.removeEventListener("replayVideo", onReplayVideo);
			_videoPlayer.removeEventListener("playbackStop", onVideoStopped);
			_videoPlayer.removeEventListener("mute", onMuteVideo);
			_videoPlayer.removeEventListener("pause", onPauseVideo);
			_videoPlayer.removeEventListener("streamFail", onVideoFailed);
			_videoPlayer.removeEventListener("videoNotFound", onVideoFailed);
			_videoPlayer.removeEventListener("videoNotFound", onVideoFailed);
			_videoPlayer.removeEventListener("sOnError", onVideoFailed);
			_videoPlayer.removeEventListener("mediaFileChosen", onMediaFileChosen);

			_videoPlayer = null;
		}	
		
		//resizes the video screen
		public function resize(width:Number, height:Number, adContainerParentWidth:Number, adContainerParentHeight:Number, adContainerParentX:Number, adContainerParentY:Number):void
		{
			UIFDebugMessage.getInstance()._debugMessage(3, "In onResize: Resizing EWVIdeoAdScreen " , "VAST", "EWVideoAdScreenModule" );
			
			setWidth(width);
			setHeight(height);
			setAdContainerParentWidth(adContainerParentWidth);
			setAdContainerParentHeight(adContainerParentHeight);
			setAdContainerParentX(adContainerParentX);
			setAdContainerParentY(adContainerParentY);
			setScaleVideo(_scaleVideo)
			setPositionVideo(_positionVideo);
			
			_videoPlayer.resizeVideoScreen(width, height,adContainerParentWidth,adContainerParentHeight, adContainerParentX, adContainerParentY, _scaleVideo, _positionVideo);
		}

		//private methods and events handlers
		public function onPlayBackStart(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(3, "0% of Video Reached", "VAST", "EWVideoAdScreenModule" );
			dispatchEvent(new Event("start"));
		}
		
		public function onFirstQuartile(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(3, "25% of Video Reached", "VAST", "EWVideoAdScreenModule");
			dispatchEvent(new Event("firstQuartile"));
		}
		
		public function onMidOfVideo(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(3, "50% of Video Reached", "VAST", "EWVideoAdScreenModule");
			dispatchEvent(new Event("midPoint"));
		}
		
		public function onThirdQuartile(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(3, "75% of Video Reached", "VAST", "EWVideoAdScreenModule");
			dispatchEvent(new Event("thirdQuartile"));
		}
		
		public function onEndOfVideo(e:Event):void
		{
			clearTimeout( _stopInterval );
			
			UIFDebugMessage.getInstance()._debugMessage(3, "100% of Video Reached", "VAST", "EWVideoAdScreenModule");
			dispatchEvent(new Event("complete"));
		}
		
		public function onVideoStopped(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(3, "In onVideoStopped()", "VAST", "EWVideoAdScreenModule");
			dispatchEvent(new Event("stop"));
			
			clearTimeout( _stopInterval );
			
			_stopCheckTime = _videoPlayer.time;
			_stopInterval = setTimeout( videoStoppedTimer, 3000 );
		}
		
		public function videoStoppedTimer( ):void {
			clearTimeout( _stopInterval );
			
			try {
				if ( _videoPlayer.time > _stopCheckTime || _videoPlayer.isPaused ) return;
				
				_videoPlayer.dispatchEvent( new Event("endOfVideo") );
			} catch ( e:Error ) { }
		}
		
		public function onReplayVideo(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(3, "In onReplayVideo()", "VAST", "EWVideoAdScreenModule");
			dispatchEvent(new Event("replay"));	
		}
		
		public function onPauseVideo(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(3, "In onPauseVideo()", "VAST", "EWVideoAdScreenModule");
			dispatchEvent(new Event("pause"));
		}
		
		public function onMuteVideo(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(3, "In onMuteVideo()", "VAST", "EWVideoAdScreenModule");
			dispatchEvent(new Event("mute"));
		}
		
		public function onVideoFailed(e:Event):void
		{
			UIFDebugMessage.getInstance()._debugMessage(3, "In onVideoFailed()", "VAST", "EWVideoAdScreenModule");
			dispatchEvent(new Event("error"));
		}
		
		public function onMediaFileChosen(e:ChosenMediaFileEvent):void
		{
			UIFDebugMessage.getInstance()._debugMessage(3, "In onMediaFileChosen() ", "VAST", "EWVideoAdScreenModule");
			var width:Number = e.width;
			var height:Number = e.height;
			dispatchEvent(new ChosenMediaFileEvent("mediaFileChosen", width, height));
		}
		
		//getters and setters
		public function getVideoPlayer():VideoPlayer
		{
			return _videoPlayer;
		}
		
		public function getVideoTime():Number
		{
			return _videoPlayer.time;
		}
		
		public function getVideoLength():Number
		{
			return _videoPlayer.videoLength;
		}
		
		public function setMediaFile(value:Array):void
		{
			_mediaFile = value;
		}
		
		public function getMediaFile():Array
		{
			return _mediaFile;
		}
		
		public function setVolume(value:Number):void
		{
			_volume = value;
			_videoPlayer.volume = value;
		}
		
		public function getVolume():Number
		{
			return _volume;
		}
		
		public function setDuration(value:Number):void
		{
			_duration = value;
		}
		
		public function getDuration():Number
		{
			return _duration;
		}
		
		public function setErrorID(value:Number):void
		{
			_errorID = value;
		}
		
		public function getErrorID():Number
		{
			return _errorID;
		}
		
		public function setErrorDescription(value:String):void
		{
			_errorDescription = value;
		}
		
		public function getErrorDescription():String
		{
			return _errorDescription;
		}
		
		public function setBwDetectProgressiveURL(value:String):void
		{
			var fileExt:String = value.substring(value.lastIndexOf("."), value.length); 
			if(fileExt != ".png" && fileExt != ".bmp" && fileExt != ".gif" && fileExt != ".jpg")
			{
				//UIFDebugMessage.getInstance()._debugMessage(2, "Unsupported file extension used for detecting bandwidth. Resuming Video ", "VAST", "EWVideoAdScreenModule");
				//dispatchEvent(new Event("error"));
				UIFDebugMessage.getInstance()._debugMessage(2, "Bandwidth detection file omitted or unsupported file extension used for detecting bandwidth. Set default bandwidth to " + _defaultBandwidth +" kb/s", "VAST", "EWVideoAdScreenModule");
				setBandWidth( _defaultBandwidth );
			}
			else
			{
				_bwDetectProgressiveURL = value;
			}	
			
		}

		
		public function getBwDetectProgressiveURL():String
		{
			return _bwDetectProgressiveURL;
		}
		
		public function setBwDetectStreamingServer(value:String):void
		{
			_bwDetectStreamingServer = value;
		}
		
		public function getBwDetectStreamingServer():String
		{
			return _bwDetectStreamingServer;
		}
		
		public function setQualityFirst(value:Boolean):void
		{
			_qualityFirst = value;
		}
		
		public function getQualityFirst():Boolean
		{
			return _qualityFirst;
		}
		
		public function setPreferredDeliveryMethod(value:String):void
		{
			_preferredDeliveryMethod = value;
		}
		
		public function getPreferredDeliveryMethod():String
		{
			return _preferredDeliveryMethod;
		}
		
		public function setScaleVideo(value:Boolean):void
		{
			_scaleVideo = value;
		}
		
		public function setPositionVideo(value:Boolean):void
		{
			_positionVideo = value;
		}
		
		public function getScaleVideo():Boolean
		{
			return _scaleVideo;
		}
		
		public function getPositionVideo():Boolean
		{
			return _positionVideo;
		}
		
		public function setAdContainerParentWidth(value:Number):void
		{
			_adContainerParentWidth = value;
		}
		
		public function getAdContainerParentWidth():Number
		{
			return _adContainerParentWidth;
		}
		
		public function setAdContainerParentHeight(value:Number):void
		{
			_adContainerParentHeight = value;
		}
		
		public function getAdContainerParentHeight():Number
		{
			return _adContainerParentHeight;
		}
		
		public function setAdContainerParentX(value:Number):void
		{
			_adContainerParentX = value;
		}
		
		public function getAdContainerParentX():Number
		{
			return _adContainerParentX;
		}
		
		public function setAdContainerParentY(value:Number):void
		{
			_adContainerParentY = value;
		}
		
		public function getAdContainerParentY():Number
		{
			return _adContainerParentY;
		}

		public function setHeight(value:Number):void
		{
			_height = value;
		}
		
		public function getHeight():Number
		{
			return _height;
		}
		
		public function setWidth(value:Number):void
		{
			_width = value;
		}
		
		public function getWidth():Number
		{
			return _width;
		}
	
		public function getBandWidth():Number
		{
			return _videoPlayer.bandwidth;
		}
		
		public function setBandWidth(value:Number):void
		{
			_videoPlayer.bandwidth = value;
		}
	}
}