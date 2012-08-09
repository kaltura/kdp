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
package com.kaltura.roughcut.buffering
{
	import com.kaltura.assets.abstracts.AbstractAsset;
	import com.kaltura.base.IDisposable;
	import com.kaltura.base.types.MediaTypes;
	import com.kaltura.managers.downloadManagers.types.StreamingModes;
	import com.kaltura.net.downloading.LoadingStatus;
	import com.kaltura.net.interfaces.IMediaSource;
	import com.kaltura.net.nonStreaming.SWFLoaderMediaSource;
	import com.kaltura.net.streaming.ExNetStream;
	import com.kaltura.net.streaming.NetClient;
	import com.kaltura.plugin.types.transitions.TransitionTypes;
	import com.kaltura.roughcut.Roughcut;
	import com.kaltura.roughcut.buffering.events.BufferEvent;

	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	* Dispatched when the roughcut was fully downloaded to the client's machine.
	* @eventType com.kaltura.roughcut.buffering.events.BufferEvent.DOWNLOAD_COMPLETE
	*/
	[Event(name="downloadComplete", type="com.kaltura.roughcut.buffering.events.BufferEvent")]
	/**
	* Dispatched when the roughcut completed downloading the plugins.
	* @eventType com.kaltura.roughcut.buffering.events.BufferEvent.PLUGINS_DOWNLOAD_COMPLETE
	*/
	[Event(name="pluginsDownloadComplete", type="com.kaltura.roughcut.buffering.events.BufferEvent")]

	/**
	 * Buffer Manager monitors loading for roughcuts.
	 * <p>Coupled with the <code>downloadManager</code>, buffer manager can give status
	 * of the roughcut's loading at a given timestamp or by a specified asset.</p>
	 */
	public class BufferMonitor extends EventDispatcher implements IDisposable
	{
		/**
		 *holds references to all the assets in the roughcut in a two dimentional array.
		 *@see com.kaltura.roughcut.buffering.BufferMonitor#buildBufferArray
		 */
		private var _buffer:Array = [];

		private var _monitoredRoughcut:Roughcut = null;
		/**
		 * the roughcut to monitor.
		 */
		public function get monitoredRoughcut ():Roughcut
		{
			return _monitoredRoughcut;
		}
		public function set monitoredRoughcut (monitored_roughcut:Roughcut):void
		{
			_monitoredRoughcut = monitored_roughcut;
		}

		/**
		 *timer for automatic progress monitoring (as oppose to pulled monitoring using <code>checkBufferTime</code>).
		 */
		private var monitorDownloadTimer:Timer = new Timer (100);

		/**
		 *determine if we dispatched an event to notify the plugins are fully loaded.
		 */
		private var pluginsLoadedDispatched:Boolean = false;

		private var _bufferedTime:uint = 0;
		/**
		 * the current cached state in milliseconds.
		 */
		[Bindable (event="updateBufferTime")]
		[Inspectable]
		public function get bufferedTime ():uint
		{
			return _bufferedTime;
		}
		protected function setBufferedTime (value:uint):void
		{
			value = Math.max(value, _bufferedTime);
			if (value != _bufferedTime)
			{
				_bufferedTime = value;
				dispatchEvent(new BufferEvent (BufferEvent.UPDATE_BUFFER_TIME));
			}
		}

		/**
		 *Constructor.
		 * @param monitored_roughcut		the roughcut to monitor.
		 */
		public function BufferMonitor (monitored_roughcut:Roughcut):void
		{
			pluginsLoadedDispatched = false;
			_monitoredRoughcut = monitored_roughcut;
			buildBufferArray();
		}

		/**
		 * build a buffer of the monitored roughcut.
		 * <p>a buffer is a two dimentional array that holds references to the roughcut's assets ordered by timestamp in seconds ranges.
		 * the following roughcut:
		 * <code>
		 * 			A: 0-2
		 * 			B:    3---7
		 * 			C: 0--3
		 * 			D:  1-----7
		 * </code>
		 * will be represented by the buffer (holding references to the assets):<br />
		 * <code>
		 * 			0 1 2 3 4 5 6 7
		 * 			A A A B B B B B
		 * 			C C C C
		 * 			  D D D D D D D
		 * </code>
		 * </p>
		 */
		public function buildBufferArray ():void
		{
			var assets:Array = _monitoredRoughcut.roughcutTimelines.roughtcutAssets.source;
			_buffer = [];
			var N:int = assets.length;
			var asset:AbstractAsset;
			var j:int;
			var i:int;
			var z:int;
			var maxSecond:uint = _monitoredRoughcut.duration >>> 0;
			var startSec:int;
			var endSec:int;
			for (i = 0; i < maxSecond; ++i)
			{
				for (j = 0; j < N; ++j)
				{
					asset = assets[j];
					startSec = asset.seqStartPlayTime >>> 0;
					endSec = asset.seqEndPlayTime >>> 0;
					if (i <= endSec)
						if (i >= startSec)
							addAssetAtTime (i, asset);
				}
			}
		}

		/**
		 *adds an asset to the buffer at specific time stamp.
		 * @param cTimeSec		the timestamp (second) to add the asset at.
		 * @param asset			the asset to add.
		 */
		public function addAssetAtTime (cTimeSec:uint, asset:AbstractAsset):void
		{
			if (_buffer[cTimeSec] == null) _buffer[cTimeSec] = [];
			var secAssets:Array = _buffer[cTimeSec];
			secAssets.push(asset);
		}

		/**
		 *check if there is enough data at a given timestamps range.
		 * @param startTime		the start time stamp.
		 * @param lookAhead		the duration to look ahead from the start timestamp.
		 * @param onlyPlugins	monitor only the plugins in the roughcut.
		 * @return 				true if there is enough data, otherwise false.
		 */
		public function checkBufferTime (startTime:uint, lookAhead:uint, onlyPlugins:Boolean = false, fromMonitorDownload:Boolean = false):Boolean
		{
			var assets:Array;
			var N:int;
			var check:Boolean = true;
			var ns:ExNetStream;
			var nclient:NetClient;
			var imgBd:BitmapData;

			//if we already know the desired time is buffered, return true.
			if ((startTime + lookAhead) <= bufferedTime)
				return true;

			//check the buffer for each second from startTime to startTime + lookAhead
			for (var z:uint = 0; z <= lookAhead; ++z)
			{
				if ((startTime + z) < _buffer.length)
				{
					assets = _buffer[(startTime + z)];
					if (!assets)
						continue;

					N = assets.length;
					for (var i:int = 0; i < N; ++i)
					{
						var asset:AbstractAsset = assets[i];

						// check if we should only monitor the plugins (this is used to pre-buffer plugins before allowing any play/seek.
						// needs to be reviewed, currently used to rebuild the roughcut after the plugins loaded, because the plugins
						// are the ones to hold the ability to build their properties (we might use Plugin Abstract for this).
						if (onlyPlugins)
							if (asset.mediaType != MediaTypes.TRANSITION &&
								asset.mediaType != MediaTypes.OVERLAY &&
								asset.mediaType != MediaTypes.EFFECT)
									continue;

						//for every mediaType there is a different check method:
						switch (asset.mediaType)
						{
							case MediaTypes.AUDIO:
								check = checkAudioStreamDownload (startTime, z, asset);
								break;

							case MediaTypes.VOICE:
							case MediaTypes.VIDEO:
								check = checkVideoStreamDownload (startTime, z, asset);
								break;

							case MediaTypes.IMAGE:
								check = checkImageDownload (asset);
								break;

							case MediaTypes.TRANSITION:
								if (asset.transitionPluginID == TransitionTypes.NONE)
								{
									check = true;
									break;
								} else {
									check = asset.mediaSource != null;
								}
								break;

							case MediaTypes.OVERLAY:
								check = asset.mediaSource != null;
								break;

							case MediaTypes.SWF:
								var swfloader:SWFLoaderMediaSource = asset.mediaSource as SWFLoaderMediaSource;
								check = swfloader != null && swfloader.content != null;
								break;
						}
						if (check == false) {
							break;
						}
					}
					if (check == false) {
						break;
					}
				} else {
					break;
				}
			}
			if (fromMonitorDownload)
			{
				//if buffer check succeeded, update the buffer time.
				var newBufferedTime:uint = startTime + z;
				if (newBufferedTime >= (_buffer.length - 1))
					newBufferedTime = _monitoredRoughcut.roughcutDuration;
				setBufferedTime (newBufferedTime);
			}
			return check;
		}

		/**
		 * validate if an image asset was downloaded.
		 * @param asset			the asset to validate.
		 */
		private function checkImageDownload (asset:AbstractAsset):Boolean
		{
			var check:Boolean;
			var imgBd:BitmapData;
			if (asset.mediaSourceLoader != null && asset.mediaSourceLoader.status == LoadingStatus.ERROR)
			{
				check = false;
				trace ("Warning: image can't be loaded: " + asset.mediaSourceLoader.url);
			} else {
				try
				{
					imgBd = (asset.mediaSource as IMediaSource).mediaBitmapData;			//Check if it's a valid bitmapData
					if (imgBd)
					{
						if (imgBd.width == 0 || imgBd.height == 0 || imgBd.rect == null)
						{
							check = false;
						} else {
							//the image is valid and ready to be shown.
							check = true;
						}
						imgBd.dispose();
						imgBd = null;
					} else {
						check = false;
					}
				} catch (e:Error)
				{
					//image is falsly loaded or haven't loaded yet.
					check = false;
				}
			}
			return check;
		}

		/**
		 * validates if a stream download is completed to a time given.
		 * @param startTime			the time to start looking at.
		 * @param lookAhead			number of seconds to check ahead.
		 * @param asset				the asset to validate.
		 * @return 					true if the given asset's download is completed to the given time.
		 */
		private function checkAudioStreamDownload (startTime:uint, lookAhead:uint, asset:AbstractAsset):Boolean
		{
			var check:Boolean;
			var ns:ExNetStream;
			ns = asset.mediaSource;
			if (ns != null)
			{
				if (asset.mediaSourceLoader)
				{
					if (asset.mediaSourceLoader.status == LoadingStatus.COMPLETE || asset.mediaSourceLoader.status == LoadingStatus.ERROR)
					{
						check = true;
					} else {
						check = (asset.mediaSourceLoader.bytesLoaded / 500) >= (startTime + lookAhead);
					}
				} else {
					check = true;
				}
			} else {
				check = false;
			}
			return check;
		}

		/**
		 * validates if a stream download is completed to a time given.
		 * @param startTime			the time to start looking at.
		 * @param lookAhead			number of seconds to check ahead.
		 * @param asset				the asset to validate.
		 * @return 					true if the given asset's download is completed to the given time.
		 */
		private function checkVideoStreamDownload (startTime:uint, lookAhead:uint, asset:AbstractAsset):Boolean
		{
			var check:Boolean;
			var ns:ExNetStream;
			var nclient:NetClient;
			ns = asset.mediaSource;
			if (ns != null)
			{
				nclient = ns.client as NetClient;
				if (nclient && nclient.metaData != null)
				{
					var sec:Number;
					startTime = startTime > 0 ? startTime : 1;
					if (_monitoredRoughcut.streamingMode == StreamingModes.PROGRESSIVE_STREAM_DUAL)
						sec = fixNum (startTime + lookAhead - asset.realSeqStreamSeekTime);
					else
						sec = fixNum (startTime + lookAhead - asset.seqStartPlayTime);
					//time in seconds, the bytes accumulated and true if it was a percise seek keyframe match or false if not:
					var seekResult:Array = nclient.metaData.seekToPreciseKeyframe (sec, 0);
					if (nclient.metaData.times != null)
					{
						if (sec <= (nclient.metaData.times[nclient.metaData.times.length-1]))
						{
							check = (asset.mediaSourceLoader.bytesLoaded >= asset.mediaSourceLoader.totalBytes) ? true :
										(asset.mediaSourceLoader.bytesLoaded >= seekResult[1]);
							/* (asset.mediaSourceLoader.bytesLoaded - asset.startByte >= seekResult[1]);
							if (check)
								trace ("buffering: ", (asset.mediaSourceLoader.bytesLoaded - asset.startByte), seekResult[1], seekResult[0]); */
						} else {
							if (asset.mediaSourceLoader)
								check = asset.mediaSourceLoader.status == LoadingStatus.COMPLETE;
							else
								check = false;
						}
					} else {
						if (asset.mediaSourceLoader)
							check = asset.mediaSourceLoader.status == LoadingStatus.COMPLETE;
						else
							check = false;
					}
				} else {
					if (asset.mediaSourceLoader)
						check = asset.mediaSourceLoader.status == LoadingStatus.COMPLETE;
					else
						check = false;
				}
			} else {
				check = false;
			}
			return check;
		}

		private function fixNum(value:Number):Number
		{
			return ((value*1000)>>>0)/1000;
		}

		/**
		 * determine if this buffer is now monitoring the whole download status.
		 */
		public function get monitorDownload ():Boolean
		{
			return monitorDownloadTimer.hasEventListener (TimerEvent.TIMER);
		}

		/**
		 *determine if the buffer should monitor the download status of the roughcut.
		 * @param val		should monitor or not.
		 *
		 */
		public function set monitorDownload (val:Boolean):void
		{
			if (val)
			{
				monitorDownloadTimer.addEventListener(TimerEvent.TIMER, monitorRoughcutDownload);
				monitorDownloadTimer.start();
			} else {
				monitorDownloadTimer.removeEventListener(TimerEvent.TIMER, monitorRoughcutDownload);
				monitorDownloadTimer.stop();
			}
		}

		/**
		 * monitors the roughcut's download status and when finished, dispatches downloadComplete event.
		 */
		private function monitorRoughcutDownload (event:TimerEvent):void
		{
			if (!pluginsLoadedDispatched)
			{
				if (checkBufferTime(0, monitoredRoughcut.duration, true))
				{
					pluginsLoadedDispatched = true;
					dispatchEvent(new BufferEvent (BufferEvent.PLUGINS_DOWNLOAD_COMPLETE));
				}
			}

			if (checkBufferTime(bufferedTime, (monitoredRoughcut.duration - bufferedTime) >>> 0, false, true))
			{
				monitorDownloadTimer.removeEventListener(TimerEvent.TIMER, monitorRoughcutDownload);
				monitorDownloadTimer.stop();
				dispatchEvent(new BufferEvent (BufferEvent.DOWNLOAD_COMPLETE));
			}
		}

		/**
		 *tosrting of the object.
		 * @return 	a string representing the buffer.
		 */
		override public function toString():String
		{
			var asset:AbstractAsset;
			var N:int = _buffer.length;
			var M:int, i:int, j:int;
			var assets:Array;
			var str:String = "[BufferManager: " + N + "]\n";
			for (i = 0; i < N; ++i)
			{
				str += "[" + i + "] - ";
				assets = _buffer[i];
				M = assets.length;
				for (j = 0; j < M; ++j)
				{
					asset = assets[j];
					str += "\t" + "{" + j + ":" + asset.entryName + " (" + asset.seqStartPlayTime.toPrecision(4) + " - " + asset.seqEndPlayTime.toPrecision(4) + ")" + "}";
				}
				str += "\n";
			}
			return str;
		}

		/**
		 *dispose function.
		 */
		public function dispose ():void
		{
			monitorDownloadTimer.stop();
			monitorDownloadTimer.reset();
			monitorDownloadTimer.removeEventListener(TimerEvent.TIMER, monitorRoughcutDownload);
			_buffer = [];
			_monitoredRoughcut = null;
		}
	}
}