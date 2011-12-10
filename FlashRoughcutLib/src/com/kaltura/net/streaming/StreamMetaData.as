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
	import com.kaltura.net.streaming.codecs.VideoCodecTypes;

	import flash.events.EventDispatcher;

	import mx.events.MetadataEvent;

	/**
	 * Serialized class for using the info recieved on onMetaData event on NetClient of ExNetStream.
	 * This class also provides methods foe advanced seek and more.
	 *
	 * @author Zohar Babin
	 * @see com.kaltura.net.streaming.ExNetStream
	 * @see com.kaltura.net.streaming.NetClient
	 */
	public class StreamMetaData extends EventDispatcher
	{
		/*
		supported vdieo codecs:
					CODEC 	 				FLASH PLAYER VERSION 	 FLASH LITE VERSION 	 CONTAINER FORMATS	 	 CODEC ID
			Sorenson Spark 2) 						6 						3 						FLV 				2
			Macromedia Screen Video 3) 				6 						- 						FLV 				3
			Macromedia ScreenVideo 2 4) 			8 						- 						FLV 				6
			On2 TrueMotion VP6-E 					8 						3 						MOV 				4
			On2 TrueMotion VP6-S 				9.0.115.0 					- 					MP4V, M4V 				5
			H.264 (MPEG-4 Part 10) 				9.0.115.0 					- 				MP4, F4V, 3GP, 3G2 			-

		supported audio codecs:
					CODEC 	 				FLASH PLAYER VERSION 	 					 	 CONTAINER FORMATS	 	 CODEC ID
			MP3 									6 												MP3 				2
			Nellymoser ASAO Codec 					6 												FLV 				5, 6
			Raw PCM sampled audio content 			6 												WAV 				0
			ADPCM 									6 																	1
			AAC (HE-AAC/AAC SBR, AAC, AAC-LC) 	9.0.115.0 										M4A, MP4
			Speex (Open source)						10 												FLV 				11

		since flash player version 9.0.115.0, metadata tags are following the standard (mandatory in h.264 files):
				PROPERTY 	 				VALUE 	 														NOTES
			duration																			Unlike for FLV files this field will always be present
			videocodecid			For H.264 it reports ‘avc1’.								@see VideoCodecTypes
			audiocodecid 			For AAC it reports ‘mp4a’, for MP3 it reports ‘.mp3’.		@see AudioCodecTypes
			avcprofile 				66, 77, 88, 100, 110, 122 or 144 							Corresponds to the H.264 profiles
			avclevel 				A number between 10 and 51. 								H264 Levels
			aottype 				Either 0, 1 or 2. 											Corresponds to AAC Main, AAC LC and SBR audio types
			moovposition 			int 														The offset in bytes of the moov atom in a file
			trackinfo 				Array 														Objects of various infomation about all the tracks in a file
			chapters 				Array 														Information about chapters in audiobooks
			seekpoints 				Array 														Times you can directly feed into NetStream.seek();
			videoframerate 			int 														The frame rate of the video if a monotone frame rate is used
			audiosamplerate 		int															The original sampling rate of the audio track
			audiochannels 			int															The original number of channels of the audio track
			tags 																				ID3 like tag information

		extra information that might be included and useful:
				PROPERTY 	 				VALUE 	 														NOTES
			width					int															The width in pixels of the video
			height					int															The height in pixels of the video
			keyframes*				int															Gop Size. concidering a CBR encoding, the frequency of keyframes
			clippedBytesOffset		int															The bytes offset of the start of a clipped stream from the original one
																									used when the clips are loaded using HTTP streaming method
																									note: will be set on the first seek request to this stream
			filepositions			Array														An alternative to 'seekpoints' array, seperates keyfarmes and filepositions
			times					Array														to two different arrays instead of array of objects, to keep lower file size.

		*keyframes, can also be an object that holds the keyframes metadata described as seekpoints (flvmdi standard),
					if passed an object instead of int, this object will be parsed to times and filepositions arrays.
		 more info on:
		 	http://osflash.org/flv
		 	http://en.wikipedia.org/wiki/H264#Levels
		 	http://developer.apple.com/documentation/QuickTime/QTFF/qtff.pdf

		*/

		/**
		 *make sure to dispatch the onMetaData event only once.
		 */
		public var dispatchedMetaData:Boolean = false;
		/**
		 *duration of the stream.
		 */
		public var duration:Number;
		/**
		 *id of the codec used in for video.
		 */
		public var videocodecid:String;
		/**
		 *id of the codec used in for audio.
		 */
		public var audiocodecid:String;
		/**
		 *corresponds to the H264 profiles.
		 *can be either: 66, 77, 88, 100, 110, 122 or 144.
		 */
		public var avcprofile:int;
		/**
		 *H264 Levels.
		 *number between 10 and 51.
		 */
		public var avclevel:int;
		/**
		 *corresponds to AAC Main, AAC LC and SBR audio types.
		 *either 0, 1 or 2.
		 */
		public var aottype:int;
		/**
		 *the offset in bytes of the moov atom in a file.
		 */
		public var moovposition:int;
		/**
		 *objects of various infomation about all the tracks in a file.
		 */
		public var trackinfo:Array;
		/**
		 *information about chapters in audiobooks.
		 */
		public var chapters:Array;
		/**
		 *the frame rate of the video if a monotone frame rate is used.
		 */
		public var videoframerate:int;
		/**
		 *the original sampling rate of the audio track.
		 */
		public var audiosamplerate:int;
		/**
		 *the original number of channels of the audio track.
		 */
		public var audiochannels:int;
		/**
		 *ID3 like tag information.
		 */
		public var tags:Array;
		/**
		 *width of the video in pixels.
		 */
		public var width:Number = 0;
		/**
		 *height of the video in pixels.
		 */
		public var height:Number = 0;
		/**
		 *the gop-size, concidering a CBR encoding this is the frequency of keyframes/frames.
		 */
		public var keyframes:Number;

		//kaltura specific:
		public var clippedBytesOffset:int = -1;
		/**
		 *bytes corresponding to the times array.
		 */
		public var filepositions:Array = null;
		/**
		 *times you can directly feed into seek function.
		 */
		public var times:Array = null;

		//TODO: should we add XMP information, or just keep it as an xml?
		protected var _xmpdata:XML;
		/**
		 * holds xmp raw xml data.
		 */
		public function get xmp ():XML
		{
			return _xmpdata;
		}
		public function set xmp (xmpdata:XML):void
		{
			_xmpdata = xmpdata;
		}

		/**
		 *state whether to keep debug info.
		 */
		public var keepDebug:Boolean = false;

		private var _onMetaDataObject:Object = null;
		/**
		 *unserialized object of the metadata, the set method will serialize this object to the streamMetaData properties.
		 */
		public function get onMetaDataObject ():Object
		{
			return _onMetaDataObject;
		}
		public function set onMetaDataObject (value:Object):void
		{
			if (keepDebug)
				_onMetaDataObject = value;
			serializeOnMetaDataObject (value);
		}

		/**
		 *Constructor.
		 * @param info			an object (info object of the NetClient) to serialize.
		 * @param keepDebug		if true will keep the original unserialized info object.
		 */
		public function StreamMetaData (info:Object = null, keep_debug:Boolean = false)
		{
			keepDebug = keep_debug;
			if (info)
				onMetaDataObject = info;
		}

		/**
		 * serializes an onMetaDataObject to the streamMetaData properties.
		 * @param info			an object (info object of the NetClient) to serialize.
		 */
		public function serializeOnMetaDataObject (info:Object):void
		{
			var i:int;
			var N:int;
			if (info.hasOwnProperty("duration"))
	        	duration = info.duration;
	        else
	        	if (info.hasOwnProperty("length"))
	        		duration = info.length;
	        	else
	        		if (info.hasOwnProperty("Len"))
	        			duration = info.Len;
	        		else
	        			if (info.hasOwnProperty("len"))
	        				duration = info.len;
			videocodecid = info.videocodecid;
			audiocodecid = info.audiocodecid;
			avcprofile = info.avcprofile;
			avclevel = info.avclevel;
			aottype = info.aottype;
			moovposition = info.moovposition;
			trackinfo = info.trackinfo;
			chapters = info.chapters;
	        if (info.hasOwnProperty("framerate"))
	        	videoframerate = info.framerate;
	        else
	        	(info.hasOwnProperty("videoframerate"))
	        		videoframerate = info.videoframerate;
	        audiosamplerate = info.audiosamplerate;
	        audiochannels = info.audiochannels;
	        tags = info.tags;
	        width = info.hasOwnProperty("width") ? info.width : 0;
	        height = info.hasOwnProperty("height") ? info.height : 0;
	        var hasKeyframesObject:Boolean = false;
	        if (info.hasOwnProperty("keyframes"))
	        {
		        if (info.keyframes is Number || info.keyframes is int || info.keyframes is uint)
		        {
		        	if (!isNaN(info.keyframes))
		        	{
		        		keyframes = Number (info.keyframes);
		        	} else {
		        		hasKeyframesObject = true;
		        	}
		        } else {
		        	hasKeyframesObject = true;
		        }
	        }
	        if (info.hasOwnProperty("times"))
	        	times = info.times;
	        if (info.hasOwnProperty("filepositions"))
	        	filepositions = info.filepositions;
	        if ((filepositions == null || times == null) &&
	        	(videocodecid == VideoCodecTypes.VIDEO_CODEC_H264 &&
	        	info.hasOwnProperty("seekpoints")) || hasKeyframesObject)
	        {
	        	if (hasKeyframesObject)
	        	{
	        		times = info.keyframes.times;
	        		//fix times to be in ms format:
	        		N = times.length;
	        		for (i = 0; i < N; ++i)
	        			times[i] = uint((times[i] * 1000)>>>0);
	        		filepositions = info.keyframes.filepositions;
	        	}
	        	if (info.hasOwnProperty("seekpoints"))
	        	{
		        	var seekpoints:Array = info.seekpoints;
		        	N = seekpoints.length;
		        	times = [];
		        	filepositions = [];
		        	var seekP:Object;
		        	for (i = 0; i < N; ++i)
		        	{
		        		seekP = seekpoints[i];
		        		if (seekP.hasOwnProperty("offset"))
		        			filepositions.push(seekP.offset);
		        		else
		        			trace ("Warning: seekpoints, offsets on h.264 file are broken");
		        		//in seekpoints, time is indicated in seconds instead of millis, so we need to convert:
		        		if (seekP.hasOwnProperty("time"))
		        			times.push(seekP.time * 1000);
		        		else
		        			trace ("Warning: seekpoints, times on h.264 file are broken");
		        	}
		        }
	        }
	        if (!dispatchedMetaData)
	        {
	        	dispatchedMetaData = true;
	        	dispatchEvent(new MetadataEvent(MetadataEvent.METADATA_RECEIVED, false, false, this));
	        }
		}

		/**
		 * On a given time in SECONDS, find the nearest last keyframe.
		 * @param time2seek		time to seek to in seconds
		 * @nearestNext			do a seek to the nearest NEXT keyframe instead of the nearest last keyframe
		 * @return 				Array that contains the keyframe; time in seconds, the bytes accumulated and true if it was a percise match or false if not.
		 */
		public function seekToPreciseKeyframe (time2seek:Number, clippedStartTime:Number, nearestNext:Boolean = false):Array
		{
			//if (clippedBytesOffset < 0)														// get the bytes offset of the clipped stream
			clippedBytesOffset = getBytesForTime (clippedStartTime);				// relative to the original stream

			var tCheck:uint = (time2seek * 1000) >> 0;											// convert the time given to millisecodns format
			var low:int = 0;

			if (times == null)
				return [0, 0, false];

			var high:int = times.length - 1;

			while (low <= high) 																// find the nearest last keyframe
			{
				var mid:int = (low + high) >>> 1;
				var midVal:int = times[mid];

				if (midVal == tCheck)
					return [time2seek, filepositions[mid] - clippedBytesOffset, true]; 			// it was a precise match, return the time in seconds, the bytes and true
				else if (midVal < tCheck)
					low = mid + 1;
				else if (midVal > tCheck)
					high = mid - 1;
			}
			var t:Number;
			var i:int;
			if (!nearestNext) {
				i = high;																		//get the nearest last keyframe
			} else {
				i = low;																		//get the nearest next keyframe
			}
			i = i >= times.length ? times.length - 1 : i;
			t = times[i] / 1000;
			return [t, filepositions[i] - clippedBytesOffset, false];  							// it's not percise, so fix it to the nearest last keyframe
																								// and return time in seconds, bytes and false
		}

		/**
		 * search for the nearest keyframe by bytes.
		 * @param current_bytes		the bytes value to search near.
		 * @param nearest_next		if true will return the next nearest keyframe value.
		 * @return 					the byte accumulated till last or next nearest keyframe and the time of the keyframe.
		 */
		public function getNearestKfBytes (current_bytes:Number, nearest_next:Boolean = false):Array
		{
			var midFind:Boolean = false;
			var low:int = 0;
			if (filepositions == null)
				return null;
			var len:int = filepositions.length - 1;
			var high:int = len;
			var mid:int = 0;
			var midVal:int = 0;
			while (low <= high) {
				mid = (low + high) >>> 1;
				midVal = filepositions[mid];
				if (midVal == current_bytes) {
					return [midVal, times[mid]];
				} else if (midVal < current_bytes) {
					low = mid + 1;
				} else if (midVal > current_bytes) {
					high = mid - 1;
				}
			}
			var i:int;
			if (!nearest_next) {
				i = high;
			} else {
				i = low;
			}
			i = i >= filepositions.length ? filepositions.length - 1 : i >= 0 ? i : 0;
			return [filepositions[i], times[i]];
		}

		/**
		 * finds the bytes offset of a specified time stamp.
		 * @param time_offset		the start time of the clipped stream from the orginal clip.
		 */
		public function getBytesForTime (time_offset:Number):int
		{
			if (times == null)
				return 0;

			var tCheck:int = (time_offset * 1000) >> 0;				//convert the time given to millisecodns format
			var low:int = 0;
			var high:int = times.length - 1;

			while (low <= high)
			{
				var mid:int = (low + high) >>> 1;
				var midVal:int = times[mid];

				if (midVal < tCheck)
					low = mid + 1;
				else if (midVal > tCheck)
					high = mid - 1;
				else
					return filepositions[mid]; 							// it was a precise match, return the time in seconds, the bytes and true
			}
			return filepositions[mid];  								//if not found, return the nearest last keyframe bytes...
		}
	}
}