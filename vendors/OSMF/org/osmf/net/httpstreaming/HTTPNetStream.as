/*****************************************************
*  
*  Copyright 2009 Adobe Systems Incorporated.  All Rights Reserved.
*  
*****************************************************
*  The contents of this file are subject to the Mozilla Public License
*  Version 1.1 (the "License"); you may not use this file except in
*  compliance with the License. You may obtain a copy of the License at
*  http://www.mozilla.org/MPL/
*   
*  Software distributed under the License is distributed on an "AS IS"
*  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
*  License for the specific language governing rights and limitations
*  under the License.
*   
*  
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.net.httpstreaming
{
	import __AS3__.vec.Vector;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamPlayOptions;
	import flash.net.NetStreamPlayTransitions;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.Timer;
	
	import org.osmf.events.DVRStreamInfoEvent;
	import org.osmf.events.HTTPStreamingFileHandlerEvent;
	import org.osmf.events.HTTPStreamingIndexHandlerEvent;
	import org.osmf.net.NetStreamCodes;
	import org.osmf.net.httpstreaming.dvr.DVRInfo;
	import org.osmf.net.httpstreaming.flv.FLVHeader;
	import org.osmf.net.httpstreaming.flv.FLVParser;
	import org.osmf.net.httpstreaming.flv.FLVTag;
	import org.osmf.net.httpstreaming.flv.FLVTagScriptDataObject;
	import org.osmf.net.httpstreaming.flv.FLVTagVideo;
	import org.osmf.net.httpstreaming.flv.FLVTagAudio;

	[Event(name="DVRStreamInfo", type="org.osmf.events.DVRStreamInfoEvent")]
	
	CONFIG::LOGGING 
	{	
		import org.osmf.logging.Logger;
	}

	CONFIG::FLASH_10_1	
	{
		import flash.net.NetStreamAppendBytesAction;
	}
	
	[ExcludeClass]

	/**
	 * 
	 * @private
	 * 
	 * HTTPNetStream is a NetStream subclass which can accept input via the
	 * appendBytes method.  In general, the assumption is that a large media
	 * file is broken up into a number of smaller fragments.
	 * 
	 * There are two important aspects of working with an HTTPNetStream:
	 * 1) How to map a specific playback time to the media file fragment
	 * which holds the media for that time.
	 * 2) How to unmarshal the data from a media file fragment so that it can
	 * be fed to the NetStream as TCMessages. 
	 * 
	 * The former is the responsibility of HTTPStreamingIndexHandlerBase,
	 * the latter the responsibility of HTTPStreamingFileHandlerBase.
	 */	
	public class HTTPNetStream extends NetStream 
	{
		/**
		 * Constructor.
		 * 
		 * @param connection The NetConnection to use.
		 * @param indexHandler Object which exposes the index, which maps
		 * playback times to media file fragments.
		 * @param fileHandler Object which canunmarshal the data from a
		 * media file fragment so that it can be fed to the NetStream as
		 * TCMessages.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function HTTPNetStream
			( connection:NetConnection
			, indexHandler:HTTPStreamingIndexHandlerBase
			, fileHandler:HTTPStreamingFileHandlerBase
			)
		{
			super(connection);
			
			_savedBytes = new ByteArray();
			
			this.indexHandler = indexHandler;
			this.fileHandler = fileHandler;
			
			indexHandler.addEventListener(HTTPStreamingIndexHandlerEvent.NOTIFY_INDEX_READY, onIndexReady);
			indexHandler.addEventListener(HTTPStreamingIndexHandlerEvent.NOTIFY_RATES, onRates);
			indexHandler.addEventListener(HTTPStreamingIndexHandlerEvent.REQUEST_LOAD_INDEX, onRequestLoadIndexFile);
			indexHandler.addEventListener(HTTPStreamingIndexHandlerEvent.NOTIFY_ERROR, onIndexError);
			indexHandler.addEventListener(HTTPStreamingIndexHandlerEvent.NOTIFY_SEGMENT_DURATION, onSegmentDurationFromIndexHandler);
			indexHandler.addEventListener(HTTPStreamingIndexHandlerEvent.NOTIFY_SCRIPT_DATA, onScriptDataFromIndexHandler);
			
			indexHandler.addEventListener(DVRStreamInfoEvent.DVRSTREAMINFO, onDVRStreamInfo);
			
			// removed NOTIFY_TIME_BIAS
			fileHandler.addEventListener(HTTPStreamingFileHandlerEvent.NOTIFY_SEGMENT_DURATION, onSegmentDurationFromFileHandler);
			fileHandler.addEventListener(HTTPStreamingFileHandlerEvent.NOTIFY_SCRIPT_DATA, onScriptDataFromFileHandler);
			fileHandler.addEventListener(HTTPStreamingFileHandlerEvent.NOTIFY_ERROR, onErrorFromFileHandler);
			
			mainTimer = new Timer(MAIN_TIMER_INTERVAL); 
			mainTimer.addEventListener(TimerEvent.TIMER, onMainTimer);	
			mainTimer.start();
			
			this.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
		}
		
		/**
		 * Whether HTTPNetStream implements enhanced seek on the client side.
		 * 
		 * Enhanced seek allows for keyframe-accurate seeking.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function set enhancedSeek(value:Boolean):void
		{
			_enhancedSeekEnabled = value;
		}
		
		public function get enhancedSeek():Boolean
		{
			return _enhancedSeekEnabled;
		}
		
		/**
		 * Getters/(setters if applicable) of a bunch of properties related to the quality of service.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get downloadRatio():Number
		{
			return _lastDownloadRatio;
		}
		
		public function set qualityLevel(value:int):void
		{
			if (_manualSwitchMode)
			{
				setQualityLevel(value);
			}
			else
			{
				throw new Error("qualityLevel cannot be set to this value at this time");
			}
		}
				
		public function get qualityLevel():int
		{
			return _qualityLevel;
		}

		public function get manualSwitchMode():Boolean
		{	
			return _manualSwitchMode;
		}
		
		public function set manualSwitchMode(value:Boolean):void
		{	
			_manualSwitchMode = value;
		}
		
		/**
		 * Initialization info for the HTTPStreamingIndexHandlerBase.
		 * 
		 * If specified, this will be passed to the index handler's
		 * initialize method when playback is initiated.  Otherwise,
		 * the argument to play (or play2) will be used.
		 **/
		public function get indexInfo():HTTPStreamingIndexInfoBase
		{
			return _indexInfo;
		}
		
		public function set indexInfo(value:HTTPStreamingIndexInfoBase):void
		{
			_indexInfo = value;
		}
		
		// new functionality
			
		public function DVRGetStreamInfo(streamName:Object):void
		{
			if (indexIsReady)
			{
				// TODO: should there be indexHandler.DVRGetStreamInfo() to re-trigger the event?
			}
			else
			{
				// TODO: should there be a guard to protect the case where indexIsReady is not yet true BUT play has already been called, so we are in an
				// "initializing but not yet ready" state? This is only needed if the caller is liable to call DVRGetStreamInfo and then, before getting the
				// event back, go ahead and call play()
				indexHandler.dvrGetStreamInfo(_indexInfo != null ? _indexInfo : streamName);
			}
		}
		
		// Overrides
		//
		
		/**
		 * The arguments to this method can mirror the arguments to the
		 * superclass's method:
		 * 1) media file
		 * 2) URL
		 * 3) name/start/len/reset
		 *		a) Subclips
		 *		b) Live
		 *		c) Resetting playlist
		 * 
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		override public function play(...args):void 
		{
			if (args.length < 1)
			{
				throw new Error("HTTPStream.play() requires at least one argument");
			}
						
			// Signal to the base class that we're entering Data Generation Mode.
			super.play(null);
			
			// Playback is considered to start when we first append some bytes.
			dispatchEvent
				( new NetStatusEvent
					( NetStatusEvent.NET_STATUS
					, false
					, false
					, {code:NetStreamCodes.NETSTREAM_PLAY_START, level:"status"}
					)
				); 
			
			// Before we feed any TCMessages to the Flash Player, we must feed
			// an FLV header first.
			//
			
			var header:FLVHeader = new FLVHeader();
			var headerBytes:ByteArray = new ByteArray();
			header.write(headerBytes);
			attemptAppendBytes(headerBytes);
			
			// Initialize ourselves and the index handler.
			//
			
			setState(HTTPStreamingState.INIT);
			_initialTime = -1;
			_seekTime = -1;
			
			indexIsReady = false;
			indexHandler.initialize(_indexInfo != null ? _indexInfo : args[0]);
		
			if (args.length >= 2)
			{
				_seekTarget = Number(args[1]);
				if (_seekTarget < 0)
				{
					if (_dvrInfo != null)
					{
						_seekTarget = _dvrInfo.startTime;
					}
					else
					{
						_seekTarget = 0;	// FMS behavior, mimic -1 or -2 being passed in
					}
				}
			}
			else
			{
				// This is the start of playback, so no seek.
				_seekTarget = 0;
			}
			
			if (args.length >= 3)
			{
				_playForDuration = Number(args[2]);
			}
			else
			{
				_playForDuration = -1;
			}

			_unpublishNotifyPending = false;
		}
		
		/**
		 * @private
		 */
		override public function play2(param:NetStreamPlayOptions):void
		{
			if (param.transition == NetStreamPlayTransitions.RESET)
			{
				// XXX Need to reset playback if we're already playing.
				// Is this done via seek?
				
				// The only difference between play and play2 for the RESET
				// case is that play2 might start at a specific quality level.
				setQualityLevelForStreamName(param.streamName);
				
				play(param.streamName, param.start, param.len);
			}
			else if (param.transition == NetStreamPlayTransitions.SWITCH)
			{
				setQualityLevelForStreamName(param.streamName);
			}
			else
			{
				// Not sure which other modes we should add support for.
				super.play2(param);
			}
		} 

		/**
		 * @private
		 */
		override public function seek(offset:Number):void
		{
			// (change to override seek rather than do this based on seek notify event)
			//  can't do this unless you're already playing (for instance, you can't leave INIT to go to SEEK)! 
			// XXX need to double-check to see if there's more guards needed here
					
			if(offset < 0)
			{
				offset = 0;		// FMS rule. Seek to <0 is same as seeking to zero.
			}
			
			if (_state != HTTPStreamingState.INIT)    // can't seek before playback starts
			{
				if(_initialTime < 0)
				{
					_seekTarget = offset + 0;	// this covers the "don't know initial time" case, rare
				}
				else
				{
					_seekTarget = offset + _initialTime;
				}
				
				_seekTime = -1;		// but _initialTime stays known
				setState(HTTPStreamingState.SEEK);		
				super.seek(offset);
			}
			
			_unpublishNotifyPending = false;
		}
		
		/**
		 * @private
		 */
		override public function close():void
		{
			indexIsReady = false;
			
			switch (_state)
			{
				case HTTPStreamingState.PLAY:
				case HTTPStreamingState.PLAY_START_NEXT:
				case HTTPStreamingState.PLAY_START_SEEK:
					_urlStreamVideo.close();	// immediate abort
			}
			setState(HTTPStreamingState.HALT);
			
			mainTimer.stop();
			
			dispatchEvent
				( new NetStatusEvent
					( NetStatusEvent.NET_STATUS
					, false
					, false
					, {code:NetStreamCodes.NETSTREAM_PLAY_STOP, level:"status"}
					)
				); 

			// XXX might need to do other things here
			super.close();
		}
		
		/**
		 * @private
		 */
		override public function get time():Number
		{
			if(_seekTime >= 0 && _initialTime >= 0)
			{
				_lastValidTimeTime = (super.time + _seekTime) - _initialTime; 
					//  we remember what we say when time is valid, and just spit that back out any time we don't have valid data. This is probably the right answer.
					//  the only thing we could do better is also run a timer to ask ourselves what it is whenever it might be valid and save that, just in case the
					//  user doesn't ask... but it turns out most consumers poll this all the time in order to update playback position displays
			}
			
			return _lastValidTimeTime;
		}
				
		// Internal
		//
		
		private function setState(value:String):void
		{
			_prevState = _state;
			_state = value;
		}
		
		private function insertScriptDataTag(tag:FLVTagScriptDataObject, first:Boolean = false):void
		{
			if (!_insertScriptDataTags)
			{
				_insertScriptDataTags = new Vector.<FLVTagScriptDataObject>();
			}
			
			if (first)
			{
				_insertScriptDataTags.unshift(tag);	// push front
			}
			else
			{
				_insertScriptDataTags.push(tag);
			}
		}
		
		private function flvTagHandler(tag:FLVTag):Boolean
		{
			// this is the new common FLVTag Parser's tag handler
			var i:int;
			
			if (_insertScriptDataTags)
			{
				for (i = 0; i < _insertScriptDataTags.length; i++)
				{
					var t:FLVTagScriptDataObject;
					var bytes:ByteArray;
					
					t = _insertScriptDataTags[i];
					t.timestamp = tag.timestamp;
					
					bytes = new ByteArray();
					t.write(bytes);
					_flvParserProcessed += bytes.length;
					attemptAppendBytes(bytes);
				}
				_insertScriptDataTags = null;			
			}
				
			if (_playForDuration >= 0)
			{
				if (_initialTime >= 0)	// until we know this, we don't know where to stop, and if we're enhanced-seeking then we need that logic to be what sets this up
				{
					var currentTime:Number = (tag.timestamp / 1000.0) + _fileTimeAdjustment;
					if (currentTime > (_initialTime + _playForDuration))
					{
						setState(HTTPStreamingState.STOP);
						_flvParserDone = true;
						if (_seekTime < 0)
						{
							_seekTime = _playForDuration + _initialTime;	// FMS behavior... the time is always the final time, even if we seek to past it
									// XXX actually, FMS  actually lets exactly one frame though at that point and that's why the time gets to be what it is
									// XXX that we don't exactly mimic that is also why setting a duration of zero doesn't do what FMS does (plays exactly that one still frame)
						}
						return false;
					}
				}
			}
			
			if (_enhancedSeekTarget < 0)
			{
				if (_initialTime < 0)
				{
					_initialTime = (tag.timestamp / 1000.0) + _fileTimeAdjustment;
				}
				
				if (_seekTime < 0)
				{
					_seekTime = (tag.timestamp / 1000.0) + _fileTimeAdjustment;
				}
			}		
			else // doing enhanced seek
			{
				if (tag is FLVTagVideo)
				{	
					if (_flvParserIsSegmentStart)	
					{
						var _muteTag:FLVTagVideo = new FLVTagVideo();
						_muteTag.timestamp = tag.timestamp; // may get overwritten, ok
						_muteTag.codecID = FLVTagVideo(tag).codecID; // same as in use
						_muteTag.frameType = FLVTagVideo.FRAME_TYPE_INFO;
						_muteTag.infoPacketValue = FLVTagVideo.INFO_PACKET_SEEK_START;
						// and start saving, with this as the first...
						_enhancedSeekTags = new Vector.<FLVTagVideo>();
						_enhancedSeekTags.push(_muteTag);
						_flvParserIsSegmentStart = false;
					}	
					
					if ((tag.timestamp / 1000.0) + _fileTimeAdjustment >= _enhancedSeekTarget)
					{
						_enhancedSeekTarget = -1;
						_seekTime = (tag.timestamp  / 1000.0) + _fileTimeAdjustment;
						if(_initialTime < 0)
						{
							_initialTime = _seekTime;
						}
						
						var _unmuteTag:FLVTagVideo = new FLVTagVideo();
						_unmuteTag.timestamp = tag.timestamp;  // may get overwritten, ok
						_unmuteTag.codecID = (_enhancedSeekTags[0]).codecID;	// take the codec ID of the corresponding SEEK_START
						_unmuteTag.frameType = FLVTagVideo.FRAME_TYPE_INFO;
						_unmuteTag.infoPacketValue = FLVTagVideo.INFO_PACKET_SEEK_END;
	
						_enhancedSeekTags.push(_unmuteTag);	
						
						// twiddle and dump
					
						for (i=0; i<_enhancedSeekTags.length; i++)
						{
							var vTag:FLVTagVideo;
							
							vTag = _enhancedSeekTags[i];
							//vTag.timestamp = tag.timestamp;
							if (vTag.codecID == FLVTagVideo.CODEC_ID_AVC && vTag.avcPacketType == FLVTagVideo.AVC_PACKET_TYPE_NALU)
							{
								// for H.264 we need to move the timestamp forward but the composition time offset backwards to compensate
								var adjustment:int = tag.timestamp - vTag.timestamp; // how far we are adjusting
								var compTime:int = vTag.avcCompositionTimeOffset;
								compTime = vTag.avcCompositionTimeOffset;
								compTime -= adjustment; // do the adjustment
								vTag.avcCompositionTimeOffset = compTime;	// save adjustment
								vTag.timestamp = tag.timestamp; // and adjust the timestamp forward
							}
							else
							{
								// the simple case
								vTag.timestamp = tag.timestamp;
							}
							bytes = new ByteArray();
							vTag.write(bytes);
							_flvParserProcessed += bytes.length;
							attemptAppendBytes(bytes);
						}
						_enhancedSeekTags = null;
						
						// and append this one
						bytes = new ByteArray();
						tag.write(bytes);
						_flvParserProcessed += bytes.length;
						attemptAppendBytes(bytes);
						if (_playForDuration >= 0)
						{
							return true;	// need to continue seeing the tags, and can't shortcut because we're being dropped off mid-segment
						}
						_flvParserDone = true;
						return false;	// and end of parsing (caller must dump rest, unparsed)
						
					} // past enhanced seek target
					else
					{
						_enhancedSeekTags.push(tag);
					}
				} // is video
				else if (tag is FLVTagScriptDataObject)
				{
					// ScriptDataObject tags simply pass through with unadjusted timestamps rather than discarding or saving for later
					bytes = new ByteArray();
					tag.write(bytes);
					_flvParserProcessed += bytes.length;
					attemptAppendBytes(bytes);
				} // else tag is FLVTagAudio, which we discard, unless...			
				else if (tag is FLVTagAudio) 
				{
					var aTag:FLVTagAudio = tag as FLVTagAudio;
					if (aTag.isCodecConfiguration)	// need to pass this through? (ex. AAC AudioConfig message)
					{
						// yes, can never skip initialization...
						bytes = new ByteArray();
						tag.write(bytes);
						_flvParserProcessed += bytes.length;
						attemptAppendBytes(bytes);
					}
				}
								
				return true;
			} // enhanced seek
			
			// finally, pass this one on to appendBytes...
			
			bytes = new ByteArray();
			tag.write(bytes);
			_flvParserProcessed += bytes.length;
			attemptAppendBytes(bytes);
			
			// probably done seeing the tags, unless we are in playForDuration mode...
			if (_playForDuration >= 0)
			{
				if (_segmentDuration >= 0 && _flvParserIsSegmentStart)
				{
					// if the segmentDuration has been reported, it is possible that we might be able to shortcut
					// but we need to be careful that this is the first tag of the segment, otherwise we don't know what duration means in relation to the tag timestamp

					_flvParserIsSegmentStart = false; // also used by enhanced seek, but not generally set/cleared for everyone. be careful.
					currentTime = (tag.timestamp / 1000.0) + _fileTimeAdjustment;
					if (currentTime + _segmentDuration >= (_initialTime + _playForDuration))
					{
						// it stops somewhere in this segment, so we need to keep seeing the tags
						return true;
					}
					else
					{
						// stop is past the end of this segment, can shortcut and stop seeing tags
						_flvParserDone = true;
						return false;
					}
				}
				else
				{
					return true;	// need to continue seeing the tags because either we don't have duration, or started mid-segment so don't know what duration means
				}
			}
			// else not in playForDuration mode...
			_flvParserDone = true;
			return false;
		}
	
		/**
		 * All decision making code for MBR switching happens in this method.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		private function autoAdjustQuality(seeking:Boolean):void
		{
			if (!_manualSwitchMode)
			{
				if (seeking)
				{
					// if we are in auto-switch, then the default is that we go to lowest rate to fulfill seek... fastest video buffer fill that way, plus for some forward seek index
					//  strategies (patent-pending) we don't even have the data we need to upswitch until we get the low-rate data
					// however, some people want to be able to control this

					setQualityLevel(0);

					return; // to avoid indenting rest of function for the else case
				}
				// auto-adjust quality level aka bitrate at this point
			
				// XXX IMPORTANT NOTE: WE AREN'T YET SETTING BUFFER TIME UPWARDS IN NON-SEEK SITUATIONS. NEED TO DO THIS SO RUNNING DRY IS LESS PAINFUL.
					
				// we work in ratios so that we can cancel kbps out of all the equations
				//   the lastDownloadRatio is "playback time of last segment downloaded" / "amount of time it took to download that whole segment, from request to finished"
				//   the switchRatio[proposed] is "claimed rate of proposed quality" / "claimed rate of current quality"
				//
				// there are exactly four cases we need to deal with, and since I'm not an optimist, I'll start from the worst case:
				// 1. the lastDownloadRatio is <1 and < switchRatio[current-1]: Bandwidth is way down, Switch to lowest rate immediately (even if there's an intermediate that might work).
				// 2. the lastDownloadRatio is <1 but >= switchRatio[current-1]: We should be able to keep going if we go down one level, do it
				// 3. the lastDownloadRatio is >= 1 but < switchRatio[current+1] OR no available rate is higher than current: Steady state where we like to be. Don't touch any knobs.
				// 4. the lastDownloadRatio is >= 1 and > switchRatio[current+1]: We can go up to rate n where n is the highest n for which lastDownloadRatio is still > switchRatio[n]
				//                                                                (but see caution about high lastDownloadRatio caused by cached response)
				//
				// XXX note: we don't currently do this, but we can hold off loading for a bit if and only if we are in state 3 AND the lastDownloadRatio is significantly >= 1
				//           (in addition to holding off loading if bufferLength is growing too far)
				// note: there is a danger that lastDownloadRatio is absurdly high because it is reflecting cached data. If that is detected, then in case 4 the switch up
				//           should only be a single quality level upwards rather than seeking the top rate instantly... just in case even one level up is actually too high a rate in reality
				//
				// XXX this is also where we could look at dropped-frame history and drop a rate level as well, if necessary. not yet implemented.
				//
				// so on to the code...
				
				var proposedLevel:int;
				var switchRatio:Number;
				
				if (_lastDownloadRatio < 1.0)
				{
					// case 1 and 2
					
					// first check to see if we are even able to switch down
					if (qualityLevel > 0)
					{
						// we are
						proposedLevel = qualityLevel - 1;
						switchRatio = _qualityRates[proposedLevel] / _qualityRates[qualityLevel];
						if (_lastDownloadRatio < switchRatio)
						{
							setQualityLevel(0);	// case 1, switch to lowest
						}
						else
						{
							setQualityLevel(proposedLevel); // case 2, down by one
						}
					}
					// else, already at lowest level
				} // case 1&2
				else
				{
					// case 3 and 4
					
					// first check to see if we are able to switch up
					if (qualityLevel < _numQualityLevels - 1) 
					{
						proposedLevel = qualityLevel + 1;
						switchRatio = _qualityRates[proposedLevel] / _qualityRates[qualityLevel];
						if (_lastDownloadRatio < switchRatio)
						{
							// case 3, don't touch anything. we're where we like to be. (well, actually, we like to be at the highest level with bandwidth to spare, but not everyone has that)
						}
						else
						{
							// is the last download ratio suspiciously high (cached data), or has aggressive upswitch been turned off?
							if (_lastDownloadRatio > 100.0 || !_aggressiveUpswitch)	// XXX 100.0 s/b constant value
							{
								// keep proposed level of +1
							}
							else
							{
								// seek better proposed level
								while (++proposedLevel < _numQualityLevels)
								{
									switchRatio = _qualityRates[proposedLevel] / _qualityRates[qualityLevel];
									if (_lastDownloadRatio < switchRatio)
										break; // found one that's too high
								}
								--proposedLevel;
							}
							setQualityLevel(proposedLevel);
						}
					}
					// else already at highest level, can't up-switch
				} // case 3&4
			} // !manualSwitch
		}
		
		private function byteSource(input:IDataInput, numBytes:Number):IDataInput
		{
			if (numBytes < 0)
			{
				return null;
			}
			
			if (numBytes)
			{
			 	if (_savedBytes.bytesAvailable + input.bytesAvailable < numBytes)
			 	{
					return null;
				}
			}
			else
			{
				if (_savedBytes.bytesAvailable + input.bytesAvailable < 1)
				{
					return null;
				}
			}
			
			if (_savedBytes.bytesAvailable)
			{
				var needed:int = numBytes - _savedBytes.bytesAvailable;
				if (needed > 0)
				{
					input.readBytes(_savedBytes, _savedBytes.length, needed);
				}
				
				return _savedBytes;
			}
			
			_savedBytes.length = 0;
			
			return input;
		}
		
		private function processAndAppend(inBytes:ByteArray):uint
		{
			var bytes:ByteArray;
			var processed:uint = 0;
			
			if (!inBytes)
			{
				return 0;
			}
			
			if (_flvParser)
			{
				inBytes.position = 0;	// rewind
				_flvParserProcessed = 0;
				_flvParser.parse(inBytes, true, flvTagHandler);	// common handler for FLVTags, parser consumes everything each time just as appendBytes does when in pass-through
				processed += _flvParserProcessed;
				if(!_flvParserDone)
				{
					// the common parser has more work to do in-path
					return processed;
				}
				else
				{
					// the common parser is done, so flush whatever is left and then pass through the rest of the segment
					bytes = new ByteArray();
					_flvParser.flush(bytes);
					_flvParser = null;	// and now we're done with it
				}
			}
			else
			{
				bytes = inBytes;
			}

			// now, 'bytes' is either what came in or what we massaged above 
			
			// (ES is now part of unified parser)
			
			processed += bytes.length;
			
			if (_state != HTTPStreamingState.STOP)	// we might exit this state
			{
				attemptAppendBytes(bytes);
			}
			
			return processed;
		}
		
		private function onMainTimer(timerEvent:TimerEvent):void
		{	
			var bytes:ByteArray;
			
			CONFIG::LOGGING
			{
				if (_state != previouslyLoggedState)
				{
					logger.debug("State = " + _state);
					previouslyLoggedState = _state;
				}
			}

			switch (_state)
			{
				case HTTPStreamingState.INIT:
					// do nothing, but not an error to be here. could make timer run slower if we wanted.
					_seekAfterInit = true;
					break;
					
			
				// SEEK case
			
				case HTTPStreamingState.SEEK:
					switch (_prevState)
					{
						case HTTPStreamingState.PLAY:
						case HTTPStreamingState.PLAY_START_NEXT:
						case HTTPStreamingState.PLAY_START_SEEK:
							_urlStreamVideo.close();	// immediate abort
							break;
						default:
							// already not open
							break;
					}
					
					_dataAvailable = false;
					_savedBytes.length = 0;		// correct? XXX
					
					if (_enhancedSeekEnabled)
					{						
						_enhancedSeekTarget = _seekTarget;
						// XXX perhaps could just reuse _seekTarget?
						// XXX there is potentially an H.264 depth issue here, where we need to do a --i to pick up enough more frames to render. must revisit.
					}
					setState(HTTPStreamingState.LOAD_SEEK);
					break;
				
				
				// LOAD cases
				case HTTPStreamingState.LOAD_WAIT:
					// XXX this delay needs to shrink proportionate to the last download ratio... when we're close to or under 1, it needs to be no delay at all
					// XXX unless the bufferLength is longer (this ties into how fast switching can happen vs. timeliness of dispatch to cover jitter in loading)
					
					// XXX for now, we have a simplistic dynamic handler, in that if downloads are going poorly, we are a bit more aggressive about prefetching
					if (this._lastDownloadRatio < 2.0)	// XXX this needs to be more linear, and/or settable
					{
						if (this.bufferLength < Math.max(7.5, this.bufferTime))	// XXX need to make settable
						{
							setState(HTTPStreamingState.LOAD_NEXT);
						}
					}
					else
					{
						if (this.bufferLength < Math.max(3.75, this.bufferTime))	// XXX need to make settable
						{
							setState(HTTPStreamingState.LOAD_NEXT);
						}					
					}
					break;
				
				case HTTPStreamingState.LOAD_NEXT:
					autoAdjustQuality(false);
					if (qualityLevelHasChanged)
					{
						bytes = fileHandler.flushFileSegment(_savedBytes.bytesAvailable ? _savedBytes : null);
						processAndAppend(bytes);
						
						// XXX for testing, putting this reporting here, but it really needs to be more informative and thus generated up in the autoAdjustQuality code
						var info:Object = new Object();
						info.code = NetStreamCodes.NETSTREAM_PLAY_TRANSITION_COMPLETE;
						info.level = "status";
						
						var sdoTag:FLVTagScriptDataObject = new FLVTagScriptDataObject();
						sdoTag.objects = ["onPlayStatus", info];
						insertScriptDataTag(sdoTag);
						
						qualityLevelHasChanged = false;
					}
					setState(HTTPStreamingState.LOAD);
					break;
					
				case HTTPStreamingState.LOAD_SEEK:
					// seek always must flush per contract
					if (!_seekAfterInit)
					{
						bytes = fileHandler.flushFileSegment(_savedBytes.bytesAvailable ? _savedBytes : null);
						// processAndAppend(bytes);	// XXX this might be unneccessary as we are about to RESET
					}
					CONFIG::FLASH_10_1
					{
						appendBytesAction(NetStreamAppendBytesAction.RESET_SEEK);
					}
					
					if (!_seekAfterInit)
					{
						autoAdjustQuality(true);
					}
						
					_seekAfterInit = false;
					setState(HTTPStreamingState.LOAD);
					break;
					
				case HTTPStreamingState.LOAD:
					
					var nextRequest:HTTPStreamRequest;
			
					// XXX the double test of _prevState in here is a little weird... might want to factor differently
					
					_segmentDuration = -1;	// we now track whether or not this has been reported yet for this segment by the Index or File handler
					switch (_prevState)
					{
						case HTTPStreamingState.LOAD_SEEK:
						case HTTPStreamingState.LOAD_SEEK_RETRY_WAIT:
							nextRequest = indexHandler.getFileForTime(_seekTarget, qualityLevel);
							break;
						case HTTPStreamingState.LOAD_NEXT:
						case HTTPStreamingState.LOAD_NEXT_RETRY_WAIT:
							nextRequest = indexHandler.getNextFile(qualityLevel);
							break;
						default:
							throw new Error("in HTTPStreamState.LOAD with unknown _prevState " + _prevState);
							break;
					}
					
					if (nextRequest != null && nextRequest.urlRequest != null)
					{
						_loadComplete = false;	

						CONFIG::LOGGING
						{
							logger.debug("loading: " + 	nextRequest.urlRequest.url.toString());
						}
											
						_urlStreamVideo.load(nextRequest.urlRequest);
						
						date = new Date();
						_lastDownloadStartTime = date.getTime();
			
						switch (_prevState)
						{
							case HTTPStreamingState.LOAD_SEEK:
							case HTTPStreamingState.LOAD_SEEK_RETRY_WAIT:
								setState(HTTPStreamingState.PLAY_START_SEEK);
								break;
							case HTTPStreamingState.LOAD_NEXT:
							case HTTPStreamingState.LOAD_NEXT_RETRY_WAIT:
								setState(HTTPStreamingState.PLAY_START_NEXT);
								break;
							default:
								throw new Error("in HTTPStreamState.LOAD(2) with unknown _prevState " + _prevState);
								break;
						}
					}
					else if(nextRequest != null && nextRequest.retryAfter >= 0)
					{
						date = new Date();
						_retryAfterWaitUntil = date.getTime() + (1000.0 * nextRequest.retryAfter);
						switch (_prevState)
						{
							case HTTPStreamingState.LOAD_SEEK:
							case HTTPStreamingState.LOAD_SEEK_RETRY_WAIT:
								setState(HTTPStreamingState.LOAD_SEEK_RETRY_WAIT);
								break;
							case HTTPStreamingState.LOAD_NEXT:
							case HTTPStreamingState.LOAD_NEXT_RETRY_WAIT:
								setState(HTTPStreamingState.LOAD_NEXT_RETRY_WAIT);
								break;
							default:
								throw new Error("in HTTPStreamState.LOAD(3) with unknown _prevState " + _prevState);
								break;
						}
					}
					else
					{
						bytes = fileHandler.flushFileSegment(_savedBytes.bytesAvailable ? _savedBytes : null);
						processAndAppend(bytes);
						setState(HTTPStreamingState.STOP);
						if (nextRequest != null && nextRequest.unpublishNotify)
						{
							_unpublishNotifyPending = true;								
						}
					}
					break;
				
				case HTTPStreamingState.LOAD_SEEK_RETRY_WAIT:								
				case HTTPStreamingState.LOAD_NEXT_RETRY_WAIT:
					var date:Date = new Date();
					if (date.getTime() > _retryAfterWaitUntil)
					{
						setState(HTTPStreamingState.LOAD);			
					}
					break;					

				case HTTPStreamingState.PLAY_START_NEXT:

					fileHandler.beginProcessFile(false, 0);
					setState(HTTPStreamingState.PLAY_START_COMMON);
					break;
					
				case HTTPStreamingState.PLAY_START_SEEK:		

					fileHandler.beginProcessFile(true, _seekTarget);
					setState(HTTPStreamingState.PLAY_START_COMMON);
					break;		
				
				case HTTPStreamingState.PLAY_START_COMMON:
					
					// need to run the common FLVParser?

					if (_initialTime < 0 || _seekTime < 0 || _insertScriptDataTags || _enhancedSeekTarget >= 0 || _playForDuration >= 0)
					{
						if (_enhancedSeekTarget >= 0 || _playForDuration >= 0)
						{
							_flvParserIsSegmentStart = true;	// warning, this isn't generally set/cleared, just used by these two cooperating things
						}
						_flvParser = new FLVParser(false);
						_flvParserDone = false;
					}
					setState(HTTPStreamingState.PLAY);
					break;
							
				case HTTPStreamingState.PLAY:

					var endSegment:Boolean = false;
					
					if (_dataAvailable)
					{
						var processLimit:int = 65000*4;	// XXX needs to be settable
						var processed:int = 0;
													
						if (_enhancedSeekTarget >= 0)
						{
							processLimit = 0;	// override slow-load
						}
						
						/*
						if(_bytesAvailable < fetchBytes)
						{
							// in the past, we simply returned in this case, figuring it was cheaper to just wait for enough to accumulate
							// we might want to revisit after performance testing
							fetchBytes = _bytesAvailable;
						}
						*/
						
						var input:IDataInput = null;
						_dataAvailable = false;
						while (_state == HTTPStreamingState.PLAY && (input = byteSource(_urlStreamVideo, fileHandler.inputBytesNeeded)))
						{
							bytes = fileHandler.processFileSegment(input);
		
							// XXX need to deal with end of file issues
							processed += processAndAppend(bytes);
							
							if (processLimit > 0 && processed >= processLimit)
							{
								_dataAvailable = true;
								break;
							}
						}
						
						if(_state != HTTPStreamingState.PLAY)
							break;
						
						// XXX if the reason we bailed is that we didn't have enough bytes, then if loadComplete we need to consume the rest into our save buffer
						// OR, if we don't do cross-segment saving then we simply need to ensure that we don't return but simply fall through to a later case
						// for now, we do the latter (also see below)
						if (_loadComplete && !input)
						{
							endSegment = true;
						}
					}
					else
					{
						if (_loadComplete)
						{
							endSegment = true;
						}
					}
					
					if (endSegment)
					{
						// then save any leftovers for the next segment round. if this is a kind of filehandler that needs that, they won't suck dry in onEndSegment.
						if (_urlStreamVideo.bytesAvailable)
						{
							_urlStreamVideo.readBytes(_savedBytes);
						}
						else
						{
							_savedBytes.length = 0; // just to be sure
						}
																	
						setState(HTTPStreamingState.END_SEGMENT);
					}
					
					break;
				
				case HTTPStreamingState.END_SEGMENT:
					// give fileHandler a crack at any remaining data 

					bytes = fileHandler.endProcessFile(_savedBytes.bytesAvailable ? _savedBytes : null);
					processAndAppend(bytes);
					_lastDownloadRatio = _segmentDuration / _lastDownloadDuration;	// urlcomplete would have fired by now, otherwise we couldn't be done, and onEndSegment is the last possible chance to report duration

					if (_state != HTTPStreamingState.STOP && _state != HTTPStreamingState.HALT)
					{ 
						setState(HTTPStreamingState.LOAD_WAIT);
					}
					break;

				case HTTPStreamingState.STOP:
						var playCompleteInfo:Object = new Object();
			            playCompleteInfo.code = NetStreamCodes.NETSTREAM_PLAY_COMPLETE;
			            playCompleteInfo.level = "status";
			                                    
			            var playCompleteInfoSDOTag:FLVTagScriptDataObject = new FLVTagScriptDataObject();
			            playCompleteInfoSDOTag.objects = ["onPlayStatus", playCompleteInfo];
			
			            var tagBytes:ByteArray = new ByteArray();
			            playCompleteInfoSDOTag.write(tagBytes);
			
			   			CONFIG::FLASH_10_1
						{
							appendBytesAction(NetStreamAppendBytesAction.END_SEQUENCE);
							appendBytesAction(NetStreamAppendBytesAction.RESET_SEEK);
						}
			            
			            attemptAppendBytes(tagBytes);
			            setState(HTTPStreamingState.HALT);
				  		
			            break;
			    		
				case HTTPStreamingState.HALT:
					// do nothing. timer could run slower in this state.
					break;

				default:
					throw new Error("HTTPStream cannot run undefined _state "+_state);
					break;
			}
		}
		
		private function onURLStatus(progressEvent:ProgressEvent):void
		{
			_dataAvailable = true;
		}
		
		private function onURLComplete(event:Event):void
		{
			var date:Date = new Date;
			
			_lastDownloadDuration = (date.getTime() - _lastDownloadStartTime) / 1000.0;
			_loadComplete = true;
		}

		private function onRequestLoadIndexFile(event:HTTPStreamingIndexHandlerEvent):void
		{
			var urlLoader:URLLoader = new URLLoader(event.request);
			var requestContext:Object = event.requestContext;
			if (event.binaryData)
			{
				urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			}
			else
			{
				urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			}
			
			urlLoader.addEventListener(Event.COMPLETE, onIndexLoadComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIndexURLError);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onIndexURLError);

			function onIndexLoadComplete(innerEvent:Event):void
			{
				urlLoader.removeEventListener(Event.COMPLETE, onIndexLoadComplete);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIndexURLError);
				urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onIndexURLError);

				indexHandler.processIndexData(urlLoader.data, requestContext);
			}
			
			function onIndexURLError(errorEvent:Event):void
			{
				urlLoader.removeEventListener(Event.COMPLETE, onIndexLoadComplete);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIndexURLError);
				urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onIndexURLError);

				handleURLError();
			}
		}

		private function onSegmentDurationFromFileHandler(event:HTTPStreamingFileHandlerEvent):void
		{
			_segmentDuration = event.segmentDuration;
		}
		
		private function onSegmentDurationFromIndexHandler(event:HTTPStreamingIndexHandlerEvent):void	// TOOD: unify this with the above so we don't need to duplicate
		{
			_segmentDuration = event.segmentDuration;
		}

		private function onRates(event:HTTPStreamingIndexHandlerEvent):void
		{
			_qualityRates = event.rates;
			_streamNames = event.streamNames;
			_numQualityLevels = _qualityRates.length;
		}	

		private function onIndexReady(event:HTTPStreamingIndexHandlerEvent):void
		{
			if (!indexIsReady)
			{
				if (event.live && _dvrInfo == null && !isNaN(event.offset))
				{
					_seekTarget = event.offset;
				}
				
				_urlStreamVideo = new URLStream();
			
				_urlStreamVideo.addEventListener(ProgressEvent.PROGRESS				, onURLStatus		, false, 0, true);	
				_urlStreamVideo.addEventListener(Event.COMPLETE						, onURLComplete		, false, 0, true);
				_urlStreamVideo.addEventListener(IOErrorEvent.IO_ERROR				, onVideoURLError	, false, 0, true);
				_urlStreamVideo.addEventListener(SecurityErrorEvent.SECURITY_ERROR	, onVideoURLError	, false, 0, true);
	
				setState(HTTPStreamingState.SEEK);	// was LOAD_SEEK, now want to pick up enhanced seek setup, if applicable. in the future, might want to change back?
				indexIsReady = true;
			}
		}
		
		private function onVideoURLError(event:Event):void
		{			
			handleURLError();
		}
		
		private function handleURLError():void
		{
			// We map all URL errors to Play.StreamNotFound.
			dispatchEvent
				( new NetStatusEvent
					( NetStatusEvent.NET_STATUS
					, false
					, false
					, {code:NetStreamCodes.NETSTREAM_PLAY_STREAMNOTFOUND, level:"error"}
					)
				);
		}

		private function onScriptDataFromIndexHandler(event:HTTPStreamingIndexHandlerEvent):void
		{
			onScriptData(event.scriptDataObject, event.scriptDataFirst, event.scriptDataImmediate);
		}
		
		private function onScriptDataFromFileHandler(event:HTTPStreamingFileHandlerEvent):void
		{
			onScriptData(event.scriptDataObject, event.scriptDataFirst, event.scriptDataImmediate);			// TODO: somehow figure out how to not need duplicate listeners
		}
		
		private function onErrorFromFileHandler(event:HTTPStreamingFileHandlerEvent):void
		{
			// We map file handler error to Play.NETSTREAM_PLAY_FILESTRUCTUREINVALID.
			setState(HTTPStreamingState.HALT);
			dispatchEvent
				( new NetStatusEvent
					( NetStatusEvent.NET_STATUS
					, false
					, false
					, {code:NetStreamCodes.NETSTREAM_PLAY_FILESTRUCTUREINVALID, level:"error"}
					)
				);
		}
		
		private function onScriptData(scriptDataObject:FLVTagScriptDataObject, scriptDataFirst:Boolean, scriptDataImmediate:Boolean):void
		{
			CONFIG::LOGGING
			{
				logger.debug("onScriptData called");
			}
			
			if (scriptDataImmediate)
			{
				if (client)
				{
					if (client.hasOwnProperty(scriptDataObject.objects[0]))
					{
						client[scriptDataObject.objects[0]](scriptDataObject.objects[1]);	// XXX note that we can only support a single argument for immediate dispatch
					}
				}
			}
			else
			{
				insertScriptDataTag(scriptDataObject, scriptDataFirst);
			}
		}
		
		private function onDVRStreamInfo(event:DVRStreamInfoEvent):void
		{
			_dvrInfo = event.info as DVRInfo;
			dispatchEvent(event.clone());
		}

		/**
		 * All errors from file index handler and file handler are passed to HTTPNetStream
		 * via MediaErrorEvent. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		private function onIndexError(event:HTTPStreamingIndexHandlerEvent):void
		{
			// We map all Index errors to Play.StreamNotFound.
			dispatchEvent
				( new NetStatusEvent
					( NetStatusEvent.NET_STATUS
					, false
					, false
					, {code:NetStreamCodes.NETSTREAM_PLAY_STREAMNOTFOUND, level:"error"}
					)
				);
		}
		
		private function setQualityLevel(value:int):void
		{
			if (value >= 0 && value < _numQualityLevels)
			{
				if (value != _qualityLevel)
				{
					_qualityLevel = value;
					qualityLevelHasChanged = true;
					dispatchEvent
						( new NetStatusEvent
							( NetStatusEvent.NET_STATUS
							, false
							, false
							, {code:NetStreamCodes.NETSTREAM_PLAY_TRANSITION, level:"status", details:_streamNames[value]}
							)
						); 
				}
			}
			else
			{
				throw new Error("qualityLevel cannot be set to this value at this time");
			}
		}
		
		private function setQualityLevelForStreamName(streamName:String):void
		{
			var level:int = -1;
			
			if (_streamNames != null)
			{
				for (var i:int = 0; i < _streamNames.length; i++)
				{
					if (streamName == _streamNames[i])
					{
						level = i;
						break;
					}
				}
			}
			
			if (level != -1)
			{
				setQualityLevel(level);
			}
		}

		private function attemptAppendBytes(bytes:ByteArray):void
		{
			// Do nothing if this is not an Argo player.
			CONFIG::FLASH_10_1
			{
				super.appendBytes(bytes);
			}
		}
		
		private function onNetStatus(event:NetStatusEvent):void
		{
			if (event.info.code == NetStreamCodes.NETSTREAM_BUFFER_EMPTY && _state == HTTPStreamingState.HALT) 
			{
				finishStopProcess();
			}
		}
		
		private function finishStopProcess():void
		{
			if (_unpublishNotifyPending)
			{
				dispatchEvent
					( new NetStatusEvent
						( NetStatusEvent.NET_STATUS
						, false
						, false
						, {code:NetStreamCodes.NETSTREAM_PLAY_UNPUBLISH_NOTIFY, level:"status"}
						)
					);
					
				_unpublishNotifyPending = false; 
			}
		}

		private static const MAIN_TIMER_INTERVAL:int = 25;
		
		private var _indexInfo:HTTPStreamingIndexInfoBase = null;
		private var _numQualityLevels:int = 0;
		private var _qualityRates:Array; 	
		private var _streamNames:Array;
		private var _segmentDuration:Number = -1;
		private var _urlStreamVideo:URLStream = null;
		private var _loadComplete:Boolean = false;
		private var mainTimer:Timer;
		private var _dataAvailable:Boolean = false;
		private var _qualityLevel:int = 0;
		private var qualityLevelHasChanged:Boolean = false;
		private var _seekTarget:Number = -1;
		private var _lastDownloadStartTime:Number = -1;
		private var _lastDownloadDuration:Number;
		private var _lastDownloadRatio:Number = 0;
		private var _manualSwitchMode:Boolean = false;
		private var _aggressiveUpswitch:Boolean = true;	// XXX needs a getter and setter, or to be part of a pluggable rate-setter
		private var indexHandler:HTTPStreamingIndexHandlerBase;
		private var fileHandler:HTTPStreamingFileHandlerBase;
		private var _totalDuration:Number = -1;
		private var _enhancedSeekTarget:Number = -1;	// now in seconds, just like everything else
		private var _enhancedSeekEnabled:Boolean = false;
		private var _enhancedSeekTags:Vector.<FLVTagVideo>;
		private var _flvParserIsSegmentStart:Boolean = false;
		private var _savedBytes:ByteArray = null;
		private var _state:String = HTTPStreamingState.INIT;
		private var _prevState:String = null;
		private var _seekAfterInit:Boolean;
		private var indexIsReady:Boolean = false;
		private var _insertScriptDataTags:Vector.<FLVTagScriptDataObject> = null;
		private var _flvParser:FLVParser = null;	// this is the new common FLVTag Parser
		private var _flvParserDone:Boolean = true;	// signals that common parser has done everything and can be removed from path
		private var _flvParserProcessed:uint;
		private var _initialTime:Number = -1;	// this is the timestamp derived at start-of-play (offset or not)... what FMS would call "0"
		private var _seekTime:Number = -1;		// this is the timestamp derived at end-of-seek (enhanced or not)... what we need to add to super.time (assuming play started at zero)
		private var _fileTimeAdjustment:Number = 0;	// this is what must be added (IN SECONDS) to the timestamps that come in FLVTags from the file handler to get to the index handler timescale
													// XXX an event to set the _fileTimestampAdjustment is needed
		private var _playForDuration:Number = -1;
		private var _lastValidTimeTime:Number = 0;
		private var _retryAfterWaitUntil:Number = 0;	// millisecond timestamp (as per date.getTime) of when we retry next
		
		private var _dvrInfo:DVRInfo = null;
		private var _unpublishNotifyPending:Boolean = false;
		
		CONFIG::LOGGING
		{
			private static const logger:org.osmf.logging.Logger = org.osmf.logging.Log.getLogger("org.osmf.net.httpstreaming.HTTPNetStream");
			
			private var previouslyLoggedState:String;
		}
	}
}
