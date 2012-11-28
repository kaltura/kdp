/*
   This file is part of the Kaltura Collaborative Media Suite which allows users
   to do with audio, video, and animation what Wiki platfroms allow them to do with
   text.

   Copyright (C) 2006-2008  Kaltura Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU Affero General Public License as
   published by the Free Software Foundation, either version 3 of the
   License, or (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU Affero General Public License for more details.

   You should have received a copy of the GNU Affero General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.

   @ignore
 */
package com.kaltura.net.streaming
{
	import com.kaltura.net.interfaces.ILoadableObject;
	import com.kaltura.net.interfaces.IMediaSource;
	import com.kaltura.net.streaming.events.ExNetStreamEvent;
	import com.kaltura.net.streaming.status.NetStatus;
	import com.kaltura.utils.url.URLProccessing;

	import flash.display.BitmapData;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	import mx.core.EventPriority;
	import mx.events.MetadataEvent;
	import mx.events.VideoEvent;

	[Event(name="OnStreamEnd", type="com.kaltura.net.streaming.ExNetStreamEvent")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="fixedSeekTime2keyframe", type="com.kaltura.net.streaming.ExNetStreamEvent")]

	/**
	 * ExNetStream is used for progressive download playing of video and audio.
	 * this class is utlized to fix all problems and enhance the base NetStream with better handling of progressive downloading.
	 * @author Zohar Babin
	 *
	 */
	public class ExNetStream extends NetStream implements IMediaSource, ILoadableObject
	{
		/**
		 *whether or not we should perform intelligent seek when trying to seek to time that wasn't downloaded yet.
		 */
		public var intelliSeek:Boolean=false;
		/**
		 * provides the last intelliseek position in msec.
		 */
		public var intelliSeekStart:uint=0;
		/**
		 * provides the last intelliseek position in bytes.
		 */
		public var intelliSeekStartBytes:uint=0;

		/**
		 *determines if a metadata object was recieved, no actions are allowed before this flag is true - (all actions will be delayed to the gotMetaData).
		 */
		protected var _gotMetaData:Boolean=false;
		public function get hasMetaData ():Boolean {return _gotMetaData;}

		/**
		 *the url / uri of this stream, the destination to play.
		 */
		protected var _streamName:String="";

		public function get streamName():String
		{
			return _streamName;
		}

		/**
		 * a unique identifier for multiple streams in aplication (internal managment).
		 */
		protected var _assetUid:String;

		/**
		 * keeps the volume of the netStream on intialization and seek.
		 */
		private var _volLevel:Number=1;

		/**
		 *determines if no commands were given between preloading play command and getMetaData event.
		 * this is used to determine if we should seek to 0 after hitting play for preloading.
		 */
		private var _preloadingNoCommands:Boolean=false;

		/**
		 *true if the user clicked play before we got metadata (probably always true otherwise we would
		 * not have started loading the netstream
		 */
		private var _gotPlayBeforeMetadata:Boolean = false;

		/**
		 *after preloading play command we need to restore the seek position to the desired seek point.
		 */
		private var _originalSeekTime:Number=0;

		/**
		 * determines if stream was forced to stop in order to reload intelliSeek.
		 */
		public var forcedToStopUpdatePlayhead:Number=-1;
		/**
		 * maintains the last play state prior to intelliSeek.
		 */
		private var stateBeforeIntelliSeek:int=-1;
		/**
		 * determine if should dispatch update playhead event (for cases where it is not needed, keep false to lower events dispatching).
		 */
		private var _dispatchUpdatePlayhead:Boolean=false;

		/**
		 * video control, a video is attached to every NetStream, because the video component is more reponsive when not switching NetStreams.
		 */
		public var streamVideo:Video;
		protected var videoWidth:Number=640;
		protected var videoHeight:Number=480;
		//protected var videoBitmapData:BitmapData;

		/**
		 * timer to detect download progress (flash doesn't provide progressEvent, so we generate it).
		 */
		protected var loadingProgressTimer:Timer=new Timer(250);
		protected var _percentageLoaded:uint=0; //the precentage loaded (%)

		/**
		 * provides a comfortable interface to get the precentage downloaded (0-100).
		 */
		public function get percentageLoaded():uint
		{
			return uint(bytesLoaded / bytesTotal * 100);
		}

		/**
		 * update the playhead progress (this provdie a more comfortable interface to know when the playhead was updated).
		 */
		protected var updatePlayheadTimer:Timer=new Timer(40);

		// buffer control:
		/**
		 * whether to load using a "dual buffer" method or not, disabled by default - for progressive we use constant buffer for easier prediction.
		 * use dual-buffer for streaming to utilize look-ahead buffer to the maximum.
		 */
		public var dualBuffer:Boolean=false;
		public var bufferTimeIncrement:Number=1; // while playing, increase the bufferTime by this value to get larger buffer and less audio jitters
		public var mStartBufferLength:Number=0.1; // default start buffer length in seconds, 0 to start immediately.
		public var mExpandedBufferLength:Number=20; // default expanded buffer length in seconds
		public var mMaximumBufferLength:Number=40; // max addings to the expanded on over bandwidth
		/**
		 *if set to true, stream will wait to full cache download before allowing playback.
		 */
		public var downloadBeforePlay:Boolean=false;

		//play control:
		/**
		 * the current playback status (buffering/play/pause, etc).
		 */
		protected var _playStatus:uint=PlayStatusStates.STOP;

		protected var _startTime:Number=0; //the time stamp at which we will start playing
		protected var _length:Number=-1; //the duration to play this stream
		protected var _isSingleFrame:Boolean=false; //should we play or just show a single frame
		protected var _willReceiveVideo:Boolean=true; //will receive video? this will get an audio only stream
		protected var isStreamEnd:Boolean=false; //has the stream finished playing ?
		private var dontRecievePlayStopEventTwice:int=0; //fix a bug in the play.stop NetStatus event (not in use, exist for debugging).
		private var lastMonitoredNetStreamTime:Number=0; //keeps the previously dispatched playhead time.
		private var areWeStuck:int=0; //fix a bug in detecting the end of a video.
		/**
		 * set true to preform a reply when stream finish playing.
		 */
		public var replayStream:Boolean=false;

		/**
		 *Constructor.
		 * @param connection		the netConnection of the stream.
		 * @param stream_name		the strem name (url if progressive).
		 * @param assetUid			the related asset unique identifier.
		 * @param start				the second at which to strat play the stream.
		 * @param duration			the duration to play the stream.
		 * @param doPreLoading		preform a pre loading of the stream after instantiation.
		 * @param isSingleFrame		deprecated -set to true if should only load a single frame (do not play).
		 * @param videoWidth		the attached video width.
		 * @param videoHeight		the attached video height.
		 *
		 */
		public function ExNetStream(connection:NetConnection, stream_name:String, assetUid:String, willReceiveAudio:Boolean, willReceiveVideo:Boolean, start:Number=0, duration:Number=-1, doPreLoading:Boolean=true, isSingleFrame:Boolean=false, width:Number=640, height:Number=480):void
		{
			super(connection);
			videoWidth=width <= 0 ? 640 : width;
			videoHeight=height <= 0 ? 480 : height;
			receiveAudio(willReceiveAudio);
			receiveVideo(willReceiveVideo);
			_willReceiveVideo=willReceiveVideo;
			_assetUid=assetUid;
			checkPolicyFile=true;
			_streamName=stream_name;
			_isSingleFrame=isSingleFrame;
			_startTime=start;
			_length=duration;
			var netClient:NetClient=new NetClient(_streamName);
			client=netClient;
			netClient.addEventListener(MetadataEvent.METADATA_RECEIVED, gotMetadata, false, EventPriority.BINDING, true);
			addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler, false, 0, true);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, netSecurityError, false, 0, true);
			addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler, false, 0, true);
			addEventListener(IOErrorEvent.IO_ERROR, netStreamIOErrorHandler, false, 0, true);
			loadingProgressTimer.addEventListener(TimerEvent.TIMER, updateLoadingProgress, false, 0, true);
			if (doPreLoading == true)
			{
				_originalSeekTime=start;
				_percentageLoaded=0;
				_volLevel=super.soundTransform.volume;
				// We set the stream volume to 0 since the audio starts rendering just before
				// the video does and creates an annoying blip. Once NetStream.Buffer.Full is reached, we set it back.
				super.soundTransform=new SoundTransform(0);

				internalPlayMedia(true);
				pauseMedia();
				_preloadingNoCommands=true;
				loadingProgressTimer.start();
			}
			else
			{
				_preloadingNoCommands=false;
			}
			receiveVideo(_willReceiveVideo);
			if (doPreLoading == true && streamVideo) streamVideo.visible = false;
		}

		/**
		 * handler for the onMetaData event.
		 */
		private function gotMetadata(event:Event):void
		{
			traceAction("XNS: gotMetadata, size: " + bytesLoaded);
			_gotMetaData=true;
			// we delay all actions till after we surely have all metadata and it is fully parsed.
			// this fixs an issue with NetStream becoming un-responsive after receiving actions before or immidiatly after
			// onMetaData.
			setTimeout(pauseAfterMetaDataLoaded, 450);
			trace("_preloadingNoCommands",_preloadingNoCommands,"_originalSeekTime",_originalSeekTime, "_gotPlayBeforeMetadata", _gotPlayBeforeMetadata);
			setTimeout(fixPlayheadAfterMetadata, 500);
/* 			if (!_preloadingNoCommands && (_originalSeekTime >= 0 || _gotPlayBeforeMetadata))
				setTimeout(fixPlayheadAfterMetadata, 500);
			else if (playStatus == PlayStatusStates.PLAY)
				streamVideo.visible = true;
 */			var nc:NetClient=client as NetClient;
			// parse length value from the metaData (unless it was previously manually set).
			if (nc && nc.metaData && nc.metaData.duration > -1 && _length == -1)
				_length=nc.metaData.duration;
			dispatchEvent(event.clone());
		}

		/**
		 * make sure we pause after metaData received, to prevent un-reponsiveness bug, we do it only after metadata is parsed.
		 */
		private function pauseAfterMetaDataLoaded():void
		{
			if (_playStatus == PlayStatusStates.PAUSE)
				pause();
		}

		/**
		 * after preloading the stream and getting metadata, we can pause the netStream and restore it's position in time.
		 */
		private function fixPlayheadAfterMetadata():void
		{
			if (_playStatus != PlayStatusStates.PLAY || _gotPlayBeforeMetadata)
			{
				trace("fixPlayheadAfterMetadata", _originalSeekTime, "_gotPlayBeforeMetadata", _gotPlayBeforeMetadata);
				seekMedia(_originalSeekTime);
			}
			if (playStatus == PlayStatusStates.PLAY && streamVideo)
				streamVideo.visible = true;

			super.soundTransform=new SoundTransform(_volLevel);
		}

		/**
		 * interface implementation (netstream is loading itself, so we return "this" as the loaded data).
		 * @return 		this.
		 *
		 */
		public function get mediaSource():IMediaSource
		{
			return this;
		}

		/**
		 * determines whether or not to dispatch update update playhead.
		 * to save events being dispatched set to false, default value is false.
		 */
		public function get dispatchUpdatePlayhead():Boolean
		{
			return _dispatchUpdatePlayhead;
		}

		public function set dispatchUpdatePlayhead(val:Boolean):void
		{
			_dispatchUpdatePlayhead=val;
			if (_dispatchUpdatePlayhead)
			{
				updatePlayheadTimer.addEventListener(TimerEvent.TIMER, dispatchTime);
				if (_playStatus == PlayStatusStates.PLAY)
					updatePlayheadTimer.start();
			}
			else
			{
				updatePlayheadTimer.removeEventListener(TimerEvent.TIMER, dispatchTime);
				updatePlayheadTimer.stop();
			}
		}

		/**
		 * handles dispatching of update playhead.
		 * this function also overcome a bug in the NetStream of not identifying the end of a video.
		 */
		private function dispatchTime(event:TimerEvent):void
		{
			if (forcedToStopUpdatePlayhead == -1)
			{
				dispatchEvent(new VideoEvent(VideoEvent.PLAYHEAD_UPDATE, false, false, null, time));
				if (lastMonitoredNetStreamTime == time)
					areWeStuck++;
				else
					areWeStuck = 0;

				lastMonitoredNetStreamTime=time;
				// if we reached the end of the stream or we're on the same value for the last 400 msecs
				// and the value is almost the same as the total length of the video - call end of stream handler.
				if (/* (_length != -1 && time >= _length) || */ (areWeStuck > 10 && Math.floor(time) >= Math.floor(_length) - 1))
					onStreamEnd(true);
			}
		}

		/**
		 *reset the stream to load a new stream.
		 * @param new_url		the url of the new stream to load.
		 *
		 */
		public function changeStreamURL(new_url:String):void
		{
			close();
			_streamName=new_url;
			loadingProgressTimer.addEventListener(TimerEvent.TIMER, updateLoadingProgress, false, 0, true);
			_playStatus=PlayStatusStates.STOP;
			_percentageLoaded=0;
			var netClient:NetClient=new NetClient(new_url);
			client=netClient;
			netClient.addEventListener(MetadataEvent.METADATA_RECEIVED, gotMetadata, false, EventPriority.BINDING, true);
			_gotMetaData=false;
			_gotPlayBeforeMetadata = false;
			internalPlayMedia(true);
			_volLevel=super.soundTransform.volume;
			// We set the stream volume to 0 since the audio starts rendering just before
			// the video does and creates an annoying blip. Once NetStream.Buffer.Full is reached, we set it back.
			super.soundTransform=new SoundTransform(0);
			pauseMedia();
			loadingProgressTimer.start();
			_preloadingNoCommands=true;
		}

		/**
		 * NetStream doesn't dispatch loading progress event, so we do it here using a timer.
		 */
		protected function updateLoadingProgress(event:TimerEvent):void
		{
			var lastPercentage:uint=_percentageLoaded;
			_percentageLoaded=uint(bytesLoaded / bytesTotal * 100);
			if (bytesLoaded == bytesTotal)
			{
				loadingProgressTimer.stop();
				dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal));
				dispatchEvent(new Event(Event.COMPLETE));
				loadingProgressTimer.removeEventListener(TimerEvent.TIMER, updateLoadingProgress);
				/* if (_playStatus != PlayStatusStates.PLAY)
				 seekMedia(_startTime, 0); */
				//return ;
			}
			var nc:NetClient=client as NetClient;
			//dispatch the progress only after we have metadata and approx. enough bytes (frames) to show the first frame:
			if (nc.metaData != null && (bytesLoaded > 50000 || bytesLoaded == bytesTotal))
			{
				if (forcedToStopUpdatePlayhead > -1)
				{
					forcedToStopUpdatePlayhead=-1;
					dispatchEvent(new Event("Buffer.Full"));
					if (stateBeforeIntelliSeek == PlayStatusStates.STOP || stateBeforeIntelliSeek == PlayStatusStates.PAUSE)
						pauseMedia();
					else if (stateBeforeIntelliSeek == PlayStatusStates.PLAY)
						playMedia();
				}
				dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal));
			}
		}

		/**
		 * The netStream object needs to be set to a start buffer of 0 before any operation inorder to get an instant reaction.
		 */
		protected function resetToStartBuffer():void
		{
			bufferTime=mStartBufferLength;
		}

		/**
		 * Play and Pause functions
		 *
		 */
		public function playMedia():void
		{
			internalPlayMedia();
		}

		public function internalPlayMedia(_force:Boolean = false):void
		{
			if (!_gotMetaData)
			{
				_preloadingNoCommands=false;
				if (!_force) // the user clicked play
				{
					_volLevel=super.soundTransform.volume;
					super.soundTransform=new SoundTransform(0);
					_gotPlayBeforeMetadata = true;
				}
			}

			isStreamEnd=false;
			dontRecievePlayStopEventTwice=0;
			// if the stream is  stopped (meaning no data is loaded yet), reload and play:
			if (_playStatus == PlayStatusStates.STOP)
			{
				if (_isSingleFrame == true)
				{
					// show only the first frame of the video and pause (only available when using Streaming Server).
					play(_streamName, _startTime, 0);
					_playStatus=stateBeforeIntelliSeek=PlayStatusStates.PAUSE;
					return ;
				}
				else
				{
					play(_streamName, _startTime);
					_percentageLoaded=0;
				}
			}
			else
			{
				resume();
			}
			_playStatus=stateBeforeIntelliSeek=PlayStatusStates.PLAY;
		}

		/**
		 * play the stream from start position in sec.
		 * @param start		sec to start on.
		 *
		 */
		public function playPartOfStream(offsetStart:Number):void
		{
			seekMedia(offsetStart);
			playMedia();
		}

		/**
		 *seek inside the stream to a given offset.
		 * we should not allow seek before the desired keyframe data was reached.
		 * @param offset			the second to seek inside the stream.
		 * @param originalStart		the start second in the original stream (use for clipper service streams).
		 * @param nearestNext		true to preform the seek to the nearest next keyframe or false to the nearest last keyframe.
		 *
		 */
		public function seekMedia(offset:Number, originalStart:Number=-1, nearestNext:Boolean=false):void
		{
			// round offset to exact millisecond otherwise our exact seek to 27.720 which is passed as 27.719999999999995
			// due to calculations will get us to the previous keyframe
			offset = Math.round(offset * 1000)/1000;
			_originalSeekTime=offset;
			if (!_gotMetaData)
				_preloadingNoCommands=false;
			var nc:NetClient=client as NetClient;
			if (nc && nc.metaData)
			{
				if (nc.metaData.times == null || nc.metaData.times.length == 0)
				{
					//metadata did not include seek times information, so try to seek without advanced seeking.
					seek(offset);
					return ;
				}
			}
			if (_willReceiveVideo == true)
			{
				if (nc)
				{
					var perciseKeyframeResult:Array=checkLoading(offset, originalStart, nearestNext);
					if (perciseKeyframeResult != null)
					{
						seek(perciseKeyframeResult[0]); //seek to the nearest last keyframe
						if (perciseKeyframeResult[2] == false) //the seek was not precise, so we have to 'fix' the user to a keyframe
						{
							dispatchEvent(new ExNetStreamEvent(ExNetStreamEvent.FIXED_SEEK_TIME_TO_KEYFRAME, _streamName, perciseKeyframeResult[0], offset));
						}
					}
					else
					{
						//perform intelliseek:
						if (intelliSeek)
						{
							var res:Array=nc.metaData.seekToPreciseKeyframe(offset, originalStart, nearestNext);
							doIntelliSeek(res[0], res[1]);
						}
						else
						{
							dispatchEvent(new ExNetStreamEvent(ExNetStreamEvent.INVALID_SEEK_TIME,_streamName, time, offset));
						}
					}
				}
				else
				{
					return ;
				}
			}
			else
			{
				//this is an audio only clip, so allow seeking as normal...
				seek(offset);
			}
		}

		/**
		 * handles intelliSeek given a time offset and bytes to seek to, intelliSeek will be done according to the time offset.
		 * @param offset			the time offset (in seconds) to perform the intelliSeek to.
		 * @param offset_bytes		the bytes offset to perform the intelliSeek to.
		 */
		private function doIntelliSeek(offset:Number, offset_bytes:uint):void
		{
			if (_streamName.indexOf(URLProccessing.urlClipVideo) == -1)
			{
				trace("can't perform intelliSeek on non-clipper urls.");
				return ;
			}
			// order of actions is crucial!
			dispatchEvent(new Event("Buffer.Empty"));
			forcedToStopUpdatePlayhead=offset;
			// keep the state to restore after loading starts.
			var tempState:int=playStatus;
			close(); //close the stream to start a new download session and stop the current one.
			intelliSeekStart=(offset * 1000) >>> 0;
			intelliSeekStartBytes=offset_bytes;
			//create the stream url.
			_streamName=URLProccessing.clipperServiceAddProgressiveStream(_streamName, intelliSeekStart);
			loadingProgressTimer.addEventListener(TimerEvent.TIMER, updateLoadingProgress, false, 0, true);
			_playStatus=PlayStatusStates.STOP;
			//decrease the buffer time to minimum in order to achieve maximum responsiveness.
			bufferTime=0.1;
			//restart loading, and pause playback caused by playMedia.
			playMedia();
			pauseMedia();
			//after new stream download will start, playback state will be restored to this.
			stateBeforeIntelliSeek=tempState;
			//monitor loading.
			loadingProgressTimer.start();
		}

		/**
		 * indicates whether this stream will get video and audio or audio only.
		 */
		override public function receiveVideo(flag:Boolean):void
		{
			super.receiveVideo(flag);
			_willReceiveVideo=flag;
			if (_willReceiveVideo)
			{
				streamVideo=new Video();
				streamVideo.width=videoWidth;
				streamVideo.height=videoHeight;
				streamVideo.smoothing=true;
				streamVideo.deblocking=0;
				streamVideo.attachNetStream(this);
			}
		}

		/**
		 * Do a seek only to a keyframe and only if there is enough data downloaded to that time.
		 * @param offset				Where to seek to. (sec)
		 * @param originalStart			The start time relative to the original Clip. that is used to deterrmine the right second in bytes array.
		 * @nearestNext					do a seek to the nearest LAST keyframe or nearest LAST keyframe
		 */
		public function checkLoading(offset:Number, originalStart:Number, nearestNext:Boolean=false):Array
		{
			var offsetMs:uint=(offset * 1000) >>> 0;
			if (offsetMs >= 0 && offsetMs >= intelliSeekStart)
			{
				var nc:NetClient=client as NetClient;
				if (nc.metaData != null)
				{
					var res:Array=nc.metaData.seekToPreciseKeyframe(offset, originalStart, nearestNext);
					var timeToSeek:uint = (res[0]*1000)>>>0;
					if ((res[1] - intelliSeekStartBytes >= bytesLoaded) && timeToSeek != intelliSeekStart)
					{
						return null; //the offset we want to seek to hasn't been downloaded yet
					}
					else
					{
						return res; //return the result, so we can seek
					}
				}
				else
				{
					return null; //if we don't have MetaData yet, we can't determine this
				}
			}
			else
			{
				return null; //given offset is not valid. maybe we should throw an error ?
			}
		}

		/**
		 * calculate the bytes loaded considering the original metadata size and flv header size including intelliseek.
		 * @param bytes		the real loaded bytes to extract relative seek bytes from.
		 * @return 			the bytes loaded considering the original metadata size and flv header size including intelliseek.
		 *
		 */
		public function getRelativeSeekBytes(bytes:uint):uint
		{
			var nc:NetClient=client as NetClient;
			if (!nc.metaData || !nc.metaData.times || !nc.metaData.filepositions)
				return bytes;
			// bytes - first kf position - flv header size
			var nb:uint=bytes - nc.metaData.filepositions[0] - 13;
			return nb - intelliSeekStartBytes;
		}

		/**
		 * Pause the steram.
		 * @return 		whether the stream was playing or not.
		 *
		 */
		public function pauseMedia():void
		{
			if (!_gotMetaData)
				_preloadingNoCommands=false;
			if (_playStatus == PlayStatusStates.PLAY)
				pause();
			_playStatus=stateBeforeIntelliSeek=PlayStatusStates.PAUSE;
		}

		/**
		 * @inherit
		 * Override function for the pause method.
		 */
		override public function pause():void
		{
			updatePlayheadTimer.stop();
			if (client is NetClient && _gotMetaData)
			{
				//traceAction ("XNS: pause");
				_volLevel=super.soundTransform.volume;
				super.pause();
			}
			_playStatus=PlayStatusStates.PAUSE;
		}

		/**
		 * @inherit
		 * Override function for the resume method.
		 */
		override public function resume():void
		{
			updatePlayheadTimer.start();
			resetToStartBuffer();

			if (_gotMetaData)
				super.soundTransform=new SoundTransform(_volLevel);

			if (client is NetClient && _gotMetaData && (!downloadBeforePlay || percentageLoaded == 100))
			{
				//traceAction ("XNS: resume");
				//reset the sound transform:
				super.resume();
				if (streamVideo)
					streamVideo.visible = true;
			}
		}

		/**
		 * @inherit
		 * Override function for the seek method.
		 * @param offset	Where to seek to. (sec)
		 *
		 */
		override public function seek(offset:Number):void
		{
			resetToStartBuffer();
			if (client is NetClient && _gotMetaData)
			{
				//traceAction ("XNS: seek: " + offset.toString());
				super.seek(offset);
				if (streamVideo)
					streamVideo.visible = true;
			}
			else
			{
				_preloadingNoCommands=true;
				_originalSeekTime=offset;
			}
		}

		/**
		 *@inherit
		 * @param sndTransform
		 *
		 */
		override public function set soundTransform(sndTransform:SoundTransform):void
		{
			super.soundTransform=sndTransform;
			_volLevel=sndTransform.volume;
		}


		/**
		 * Change the default buffer length, this doesn't flush the
		 * existing buffer, wasting bits unnecessary.
		 *
		 * @param inStartBufferLength the start buffer length in seconds. Don't set this to high, preferable to < 1 seconds to minimize buffering
		 * @param inExpandedBufferLength the expanded buffer length in seconds
		 * @return void
		 */
		public function setBufferlength(inStartBufferLength:Number, inExpandedBufferLength:Number):void
		{
			if (mStartBufferLength != inStartBufferLength)
				mStartBufferLength=inStartBufferLength;
			if (mExpandedBufferLength != inExpandedBufferLength)
				mExpandedBufferLength=inExpandedBufferLength;
		}

		/**
		 * handle security errors.
		 */
		protected function netSecurityError(event:SecurityErrorEvent):void
		{
			dispatchEvent(new Event("error"));
		}

		/**
		 * handle asynchnouse requests errors.
		 */
		protected function asyncErrorHandler(event:AsyncErrorEvent):void
		{
			// ignore this errors, just report it to log for debugging.
			traceAction("XNS: AsyncErrorEvent");
		}

		/**
		 * manual list event: "NetStream.Play.Stop" as "Playback has stopped"
		 * for pause it use: "NetStream.Pause.Notify" and described as "The stream is paused"
		 * onPlayStatus on the client with event "NetStream.Play.Complete" is never called on progressive
		 * that leaves one option: waiting for "NetStream.Play.Stop" and immidiatly after: "NetStream.Buffer.Empty"
		 * 21/08/2008 - NetStream status events are not clear,
		 * when we get stream.play.stop and buffer.empty to validate stream was stopped, play.stop keeps on firing
		 * NetStream doesn't recognize the end of stream correctly on progressive -
		 * on several cases it will fire play.stop before stream actually end playing.
		 * so we make sure the buffer is actually empty after the stop event.
		 * on other cases the buffer did not throw empty event till the 20 stop event... so we assume the end of play was
		 * reached on the 6th play.stop event.
		 * 25/08/2008 - When conversion doesn't go using Kaltura's conversion flow we get videos that the entry length
		 * is larger by a 0.05~ of ms of the actual netStream time when the video ends play, so we check that we don't
		 * miss it using the "NetStream.Play.Stop" event.
		 */
		protected function onStreamEnd(force:Boolean=false):void
		{
			if (lastMonitoredNetStreamTime == time)
				areWeStuck++;
			lastMonitoredNetStreamTime=time;
			var netStreamTime:Number=trimNumber(time, 1);
			var entryTime:Number=trimNumber(_length, 1);
			if (!_dispatchUpdatePlayhead || force == true || (entryTime != -1 && netStreamTime >= entryTime) || areWeStuck > 5)
			{
				areWeStuck=0;
				lastMonitoredNetStreamTime=0;
				dispatchEvent(new ExNetStreamEvent(ExNetStreamEvent.ON_STREAM_END, _streamName, time, -1));
				isStreamEnd=false;
				dontRecievePlayStopEventTwice=0;
				if (replayStream)
				{
					seek(0);
					playMedia();
				}
				else
				{
					seek(time);
					pause();
				}
			}
			else
			{
				isStreamEnd=false;
				dontRecievePlayStopEventTwice=0;
			}
		}

		/**
		 * helper function to trim float numbers.
		 * @param num				number to trim.
		 * @param trimPoints		number of places after the dot.
		 * @return 					trimmed number.
		 * use this function to reduce precision when comparing floats.
		 */
		private function trimNumber(num:Number, trimPoints:uint):Number
		{
			var strNum:String=num.toString();
			var prePoint:String=strNum.substr(0, strNum.indexOf("."));
			var postPoint:String=strNum.substr(strNum.indexOf("."));
			var newNum:String=prePoint + postPoint.substr(0, trimPoints + 1);
			return Number(newNum);
		}

		/**
		 * handle NetStatus events.
		 */
		protected function netStatusHandler(netEvent:NetStatusEvent):void
		{
			switch (netEvent.info.code)
			{
				case NetStatus.NETSTREAM_PAUSE_NOTIFY:
					traceAction("paused notified: " + time);
					break;
				case NetStatus.NETSTREAM_BUFFER_EMPTY:
					// if NetStream.Stop was called before this, we're at the end of the stream:
					if (isStreamEnd)
						onStreamEnd();
					dispatchEvent(new Event("Buffer.Empty"));
					// on dual buffer method, on empty we're decreasing buffer size to minimum to allow immidiate responsiveness.
					if (dualBuffer)
						bufferTime=mStartBufferLength;
					break;

				case NetStatus.NETSTREAM_BUFFER_FULL:
					if (dualBuffer)
					{
						// on dual buffer this will increase the buffer size linearly according to bufferTimeIncrement.
						if ((bufferTime >= mExpandedBufferLength) && (bufferTime < mMaximumBufferLength))
							bufferTime += bufferTimeIncrement; // expanding the maximum buffer length
						else
							bufferTime = mExpandedBufferLength; // maximum buffer length for continue loading
					}
					// if we're not immidiately after intelliSeek (where buffer is controlled by downloadProgress):
					if (forcedToStopUpdatePlayhead == -1)
						dispatchEvent(new Event("Buffer.Full"));
					break;

				case NetStatus.NETSTREAM_SEEK_NOTIFY:
					dispatchEvent(new Event("Seek.Notify"));
					break;

				case NetStatus.NETSTREAM_SEEK_INVALIDTIME:
					// currently there's no use to this - we always seek precisely to keyframes - so this should neevr be called.
					// unless metaData does not contain keyframe information...
					break;

				case NetStatus.NETSTREAM_PLAY_START:
					dispatchEvent(new Event("Play.Start"));
					break;
				case NetStatus.NETSTREAM_PLAY_STOP:
					// we've reached the end of the stream, to validate this (fixing a bug with how NetStream recognize the end)
					// we set a flag and wait for the buffer.empty and than call the end.
					isStreamEnd = true;
					// not in use anymore - just for debugging purposes.
					++dontRecievePlayStopEventTwice;
					break;

			}
		}

		/**
		 *Stop the stream. (pause and seek to 0).
		 */
		public function stop():void
		{
			if (!_gotMetaData)
				_preloadingNoCommands=false;
			pauseMedia();
			seekMedia(0);
		}

		/**
		 * draw the video on a bitmapData.
		 * @return 	bitmapData of the current video frame.
		 */
		[Deprecated]
		public function get mediaBitmapData():BitmapData
		{
			/* return null;
			   if (_willReceiveVideo == true)
			   {
			   //this is a video stream:
			   renderFrame ();
			   return videoBitmapData.clone();
			 } */
			return null;
		}

		/*
		 *renderes the current frame (draw a bitmapData of the streamVideo).
		   protected function renderFrame ():void
		   {
		   try {
		   videoBitmapData.draw (streamVideo, null, null, null, null, true);
		   } catch (err:Error) {}
		   }
		 */

		/**
		 * the state of the stream.
		 * @see com.kaltura.net.streaming.PlayStatusStates
		 */
		public function get playStatus():uint
		{
			return _playStatus;
		}

		private function netStreamIOErrorHandler(event:IOErrorEvent):void
		{
			trace("XNS: IOERROR - " + event.text);
		}

		/**
		 * helper function to trace stuff and provide the time of action (used for debugging of actions sequence).
		 * @param action		the action performed.
		 */
		private function traceAction(action:String):void
		{
			trace(getTimer(), action);
		}

		CONFIG::isSDK46 {
			/**
			 * dispose function:
			 */
			override public function dispose():void
			{
				_preloadingNoCommands=false;
				_gotMetaData=false;
				if (streamVideo)
				{
					streamVideo.clear();
					streamVideo.attachNetStream(null);
					streamVideo=null;
				}
				pause();
				close();
				client={};
				removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				removeEventListener(SecurityErrorEvent.SECURITY_ERROR, netSecurityError);
				removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				loadingProgressTimer.removeEventListener(TimerEvent.TIMER, updateLoadingProgress);
				loadingProgressTimer.stop();
			}

		}

		CONFIG::isSDK45 {
			/**
			 * dispose function:
			 */
			public function dispose():void
			{
				_preloadingNoCommands=false;
				_gotMetaData=false;
				if (streamVideo)
				{
					streamVideo.clear();
					streamVideo.attachNetStream(null);
					streamVideo=null;
				}
				pause();
				close();
				client={};
				removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				removeEventListener(SecurityErrorEvent.SECURITY_ERROR, netSecurityError);
				removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				loadingProgressTimer.removeEventListener(TimerEvent.TIMER, updateLoadingProgress);
				loadingProgressTimer.stop();
			}
		}
	}
}