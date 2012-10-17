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
package com.kaltura.roughcut.assets
{
	import com.kaltura.application.KalturaApplication;
	import com.kaltura.assets.AssetsFactory;
	import com.kaltura.assets.abstracts.AbstractAsset;
	import com.kaltura.assets.assets.PluginAsset;
	import com.kaltura.base.IDisposable;
	import com.kaltura.base.context.PartnerInfo;
	import com.kaltura.base.types.MediaTypes;
	import com.kaltura.base.types.TimelineTypes;
	import com.kaltura.base.vo.KalturaPluginInfo;
	import com.kaltura.managers.downloadManagers.DownloadManager;
	import com.kaltura.managers.downloadManagers.events.DownloadManagerStatusEvent;
	import com.kaltura.managers.downloadManagers.types.StreamingModes;
	import com.kaltura.net.downloading.LoadingStatus;
	import com.kaltura.net.streaming.ExNetStream;
	import com.kaltura.net.streaming.NetClient;
	import com.kaltura.net.streaming.StreamMetaData;
	import com.kaltura.plugin.types.transitions.TransitionTypes;
	import com.kaltura.roughcut.events.RoughcutChangeEvent;
	import com.kaltura.roughcut.events.RoughcutStatusEvent;
	import com.kaltura.roughcut.soundtrack.AudioPlayPolicy;
	import com.kaltura.utils.url.URLProccessing;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;

	import mx.collections.ArrayCollection;
	//import mx.events.PropertyChangeEvent;

	/**
	 *Manager class for managing the roughcut SDL, preforming common operations such as addEntry or setVolume...
	 */
	[Event(name="roughcutDurationChange", type="com.kaltura.roughcut.events.RoughcutChangeEvent")]
	[Event(name="roughcutSoundtrackChange", type="com.kaltura.roughcut.events.RoughcutChangeEvent")]
	[Event(name="roughcutDirty", type="com.kaltura.roughcut.events.RoughcutChangeEvent")]
	[Event(name="firstFrameLoaded", type="com.kaltura.roughcut.events.RoughcutStatusEvent")]
	//xxx [Bindable]
	public class RoughcutTimelinesAssets extends EventDispatcher implements IDisposable
	{
		protected var dManager:DownloadManager;
		// timelines arrays:
		/**
		* the video timeline.
		*/
		protected var _videoAssets:ArrayCollection = new ArrayCollection ();
		/**
		*the audio timeline.
		*/
		protected var _audioAssets:ArrayCollection = new ArrayCollection ();
		/**
		* the overlays timeline.
		*/
		protected var _overlaysAssets:ArrayCollection = new ArrayCollection ();
		/**
		* the effects timeline.
		*/
		protected var _effectsAssets:ArrayCollection = new ArrayCollection ();
		/**
		* all the timelines sorted and organized in one.
		 * @see com.kaltura.roughcut.assets.RoughcutTimelinesAssets#buildRoughcutAssets
		*/
		public var roughtcutAssets:ArrayCollection = new ArrayCollection ();
		/**
		*the entry id of this roughcut.
		*/
		public var roughcutEntryId:String = '-1';
		/**
		 *the entry version of this roughcut.
		 */
		public var roughcutEntryVersion:int = -1;
		/**
		* the total duration of the roughcut.
		*/
		[Bindable(event="roughcutDurationChange")]
		public var roughcutDuration:Number = 0;
		/**
		* the asset that represents the soundtrack if we use setSoundtrackAsset function.
		*/
		[Bindable(event="roughcutSoundtrackChange")]
		public var soundtrackAsset:AbstractAsset;
		/**
		*whether this roughcut's soundtrack asset should play once or repeat untill video timeline finish.
		*/
		[Bindable(event="roughcutSoundtrackChange")]
		public var soundtrackFirstAssetPolicy:uint = AudioPlayPolicy.AUDIO_PLAY_POLICY_ALL;
		/**
		* describe whether the soundtrack should play silently, mute or continue as is when crossing video assets.
		*/
		[Bindable(event="roughcutSoundtrackChange")]
		public var soundtrackVolumePlayPolicy:uint = AudioPlayPolicy.CROSS_VIDEO_NO_ACTION;
		/**
		* the volume at which to play the soundtrack audio asset in full volume mode.
		*/
		[Bindable(event="roughcutSoundtrackChange")]
		public var soundtrackVolume:Number = 1;
		/**
		* the volume at which to play the soundtrack audio asset in silent mode (ie crossing video).
		*/
		[Bindable(event="roughcutSoundtrackChange")]
		public var soundtrackSilentVolume:Number = AudioPlayPolicy.DEFAULT_SOUNDTRACK_SILENT_VOLUME;
		/**
		* after the roughcut assets start the loading process, dispatch firstFrameLoaded.
		*/
		public var doFirstFrame:Boolean = false;
		/**
		* mark the roughcut that the mediaSources are instantiated.
		*/
		protected var finishedLoadingProcess:Boolean = false;

		/**
		 *Constructor.
		 * @param entry_id							the entry id of this roughcut.
		 * @param video_assets						an array representation of the Visual timeline (video, image, solid, vector).
		 * @param audio_assets						an array representation of the Audio timeline.
		 * @param overlays_assets					an array representation of the overlays timeline (overlays are plugins).
		 * @param effects_assets					an array representation of the effects timeline (effects are plugins).
		 * @param soundtrack_asset					the soundtrack asset, if not null, player will repeat the this asset instead playing the audio_assets array.
		 * @param soundtrack_play_policy			whether this roughcut's soundtrack asset should play once or repeat untill video timeline finish.
		 * @param soundtrack_volume_policy			whether the soundtrack will mute, play silently or continue as is when crossing video assets.
		 * @see com.kaltura.assets.abstracts.AbstractAsset
		 * @see com.kaltura.plugin.logic.Plugin
		 * @see com.kaltura.roughcut.soundtrack.AudioPlayPolicy
		 */
		public function RoughcutTimelinesAssets (entry_id:String, entry_version:int, video_assets:Array, audio_assets:Array, overlays_assets:Array, effects_assets:Array,
												soundtrack_asset:AbstractAsset, soundtrack_play_policy:uint, soundtrack_volume_policy:uint,
												soundtrack_volume:Number, soundtrack_silent_volume:Number):void
		{
			roughcutEntryId = entry_id;
			roughcutEntryVersion = entry_version;
			_videoAssets.source = video_assets;
			_audioAssets.source = audio_assets;
			_overlaysAssets.source = overlays_assets;
			_effectsAssets.source = effects_assets;
			soundtrackAsset = soundtrack_asset;
			soundtrackFirstAssetPolicy = soundtrack_play_policy;
			soundtrackVolumePlayPolicy = soundtrack_volume_policy;
			soundtrackVolume = soundtrack_volume;
			soundtrackSilentVolume = soundtrack_silent_volume;
			dispatchEvent(new RoughcutChangeEvent (RoughcutChangeEvent.ROUGHCUT_SOUNDTRACK_CHANGE));
			dManager = DownloadManager.getInstance();
			dManager.addEventListener(DownloadManagerStatusEvent.MEDIA_LOADED, assetCompleteLoading);
		}
		//==========================================================================================
		/**
		 * builds the roughcut assets array, the roughcutAssets is used in the players.
		 * <p>this function should be run before exporting sdl in order </p>
		 * @param soundtrackAsset		the soundtrack asset for this roughcut.
		 */
		public function buildRoughcutAssets ():void
		{
			//refreshTimelines(TimelineTypes.ANY_TIMELINE);
			var timelineAssets:Array = [];
			var tempTransitionsArray:Array = [];
			var N:int;
			var seqTime:Number = 0;
			var asset:AbstractAsset;
			var maxLenVideo:Number = 0;
			var maxLenAudio:Number = 0;
			var maxLenVoice:Number = 0;
			// complete the sequence arrays for sequence Play time information:
			var transitionAsset:AbstractAsset;
			if (_videoAssets)
			{
				//Video
				N = _videoAssets.length;
				for (var i:int = 0; i < N; ++i)
				{
					// Sequence play time:
					asset = _videoAssets.getItemAt(i) as AbstractAsset;
					asset.seqStartPlayTime = seqTime;
					asset.seqEndPlayTime = seqTime + asset.length;
					if (asset.transitionCross)
					{
						seqTime = asset.seqEndPlayTime - asset.transitionLength;
					} else {
						seqTime = asset.seqEndPlayTime;
					}
					asset.orderBy = Math.floor (asset.seqStartPlayTime * 1000) * 10;
					asset.originalIndex = i;
					if (asset.transitionPluginID != TransitionTypes.NONE && asset.transitionAsset != null)
					{
						transitionAsset = asset.transitionAsset;
						if (asset.transitionCross)
						{
							transitionAsset.seqStartPlayTime = seqTime;
							transitionAsset.seqEndPlayTime = seqTime + asset.transitionLength;
						} else {
							transitionAsset.seqStartPlayTime = seqTime - asset.transitionLength;
							transitionAsset.seqEndPlayTime = seqTime;
						}
						transitionAsset.orderBy = Math.floor (transitionAsset.seqStartPlayTime * 1000) * 10 + 1;
						if (i == N - 1) {
							transitionAsset.orderBy = int.MAX_VALUE;
						}
						tempTransitionsArray.push (transitionAsset);
					}
				}
				//If the video array contains video clips,  then (N-1)>0. otherwise an exception would have been thrown.
				if (N > 0)
					maxLenVideo = _videoAssets[N-1].seqEndPlayTime;
			}

			//Audio
			if (!soundtrackAsset && _audioAssets)
			{
				N = _audioAssets.length;
				seqTime = 0;
				for (i = 0; i < N; ++i)
				{
					// Sequence play time:
					asset = _audioAssets.getItemAt(i) as AbstractAsset;
					asset.seqStartPlayTime = seqTime;
					asset.seqEndPlayTime = asset.length + seqTime;
					if (asset.transitionCross)
					{
						seqTime = asset.seqEndPlayTime - asset.transitionLength;
					} else {
						seqTime = asset.seqEndPlayTime;
					}
					asset.orderBy = Math.floor (asset.seqStartPlayTime * 1000) * 10;
					asset.originalIndex = i;
					if (asset.transitionPluginID != TransitionTypes.NONE && asset.transitionAsset != null)
					{
						transitionAsset = asset.transitionAsset;
						if (asset.transitionCross)
						{
							transitionAsset.seqStartPlayTime = seqTime;
							transitionAsset.seqEndPlayTime = seqTime + asset.transitionLength;
						} else {
							transitionAsset.seqStartPlayTime = seqTime - asset.transitionLength;
							transitionAsset.seqEndPlayTime = seqTime;
						}
						tempTransitionsArray.push (transitionAsset);
						transitionAsset.orderBy = Math.floor (transitionAsset.seqStartPlayTime * 1000) * 10 + 1;
					}
				}
				if (N > 0)
					maxLenAudio = _audioAssets.getItemAt(N-1).seqEndPlayTime;
			}

			if (_overlaysAssets)
			{
				// Overlays
				N = _overlaysAssets.length;
				seqTime = 0;
				for (i = 0; i < N; ++i)
				{
					// Sequence play time:
					asset = _overlaysAssets.getItemAt(i) as AbstractAsset;
					asset.seqEndPlayTime = asset.seqStartPlayTime + asset.length;
					asset.orderBy = Math.floor (asset.seqStartPlayTime * 1000) * 10;
					asset.originalIndex = i;
				}
			}

			if (_effectsAssets)
			{
				// Effects
				N = _effectsAssets.length;
				seqTime = 0;
				for (i = 0; i < N; ++i)
				{
					// Sequence play time:
					asset = _effectsAssets.getItemAt(i) as AbstractAsset;
					asset.seqEndPlayTime = asset.seqStartPlayTime + asset.length;
					asset.orderBy = Math.floor (asset.seqStartPlayTime * 1000) * 10;
					asset.originalIndex = i;
				}
			}

			var tempRoughcutDuration:Number = Math.max (maxLenVideo, maxLenAudio, maxLenVoice);

			if (tempRoughcutDuration != roughcutDuration)
			{
				roughcutDuration = tempRoughcutDuration;
				dispatchEvent(new RoughcutChangeEvent (RoughcutChangeEvent.ROUGHCUT_DURATION_CHANGE));
			}
			// create a new array that combines all the sequence arrays to one :
			if (_videoAssets)
				timelineAssets = _videoAssets.source.concat(tempTransitionsArray);
			if (_audioAssets)
				timelineAssets = timelineAssets.concat(_audioAssets.source);
			if (_overlaysAssets)
				timelineAssets = timelineAssets.concat(_overlaysAssets.source);
			if (_effectsAssets)
				timelineAssets = timelineAssets.concat(_effectsAssets.source);

			// sort by sequence start play time :
			timelineAssets.sortOn ("orderBy", Array.NUMERIC);
			roughtcutAssets = new ArrayCollection (timelineAssets);
		}

		/**
		 * preforms a binary search to get the asset on a given timestamp and timeline.
		 * @param target_timeline_type			the timeline on which to search.
		 * @param time_stamp					the timestamp to search.
		 * @return 								the asset on the timeline on thet specific timestamp.
		 */
		public function getAssetAtTime (target_timeline_type:uint, time_stamp:Number):AbstractAsset
		{
			var timeline:ArrayCollection = getTimelineByType (target_timeline_type);
			if (timeline.length == 0)
				return null;
			var low:int = 0;
			var high:int = timeline.length - 1;
			var asset:AbstractAsset;
			var mid:int;
			var midVal:Number;
			while (low <= high)
			{
				mid = (low + high) >>> 1;
				asset = timeline.getItemAt(mid) as AbstractAsset;
				midVal = asset.seqStartPlayTime;

				if (midVal < time_stamp)
					low = mid + 1;
				else if (midVal > time_stamp)
					high = mid - 1;
				else
					return asset;
			}
			if (high >= 0)
				return timeline.getItemAt(high) as AbstractAsset;
			else
				return timeline.getItemAt(0) as AbstractAsset;
		}

		/**
		 *retrieves the asset at the desired timeline and index.
		 * @param timeline			the timeline the asset is at.
		 * @param asset_index		the index the asset is at.
		 * @param fail_safe			if true, when given asset is beyond timeline length will return last.
		 * @return 					the asset.
		 * @see com.kaltura.assets.abstracts.AbstractAsset
		 */
		public function getAssetAt (timeline:uint, asset_index:uint, fail_safe:Boolean = false):AbstractAsset
		{
			var getItem:Function = function (array:ArrayCollection, index:int, fail_safe:Boolean):AbstractAsset
									{
										if (array.length > index && index >= 0)
										{
											return array.getItemAt(index) as AbstractAsset;
										} else {
											if (fail_safe)
											{
												if (array.length > 0)
													return array.getItemAt(array.length-1) as AbstractAsset;
												else
													return null;
											} else {
												return null;
											}
										}

									}
			if (timeline == TimelineTypes.TRANSITIONS)
			{
				var asset:AbstractAsset = getItem(_videoAssets, asset_index, fail_safe);
				return asset.transitionAsset;
			} else {
				return getItem(getTimelineByType(timeline), asset_index, fail_safe);
			}
		}

		/**
		 * return the index of an asset in it's containing timeline, returns -1 if the asset is not in this roughcut.
		 * @param asset			the asset to get it's index.
		 * @return 				the given asset's index.
		 */
		public function getAssetIndex (asset:AbstractAsset):int
		{
			if (!asset)
				return -1;
			var assetIndex:int = _videoAssets.getItemIndex(asset);
			if (assetIndex == -1)
			{
				assetIndex = _audioAssets.getItemIndex(asset);
			}
			if (assetIndex == -1)
			{
				assetIndex = _overlaysAssets.getItemIndex(asset);
			}
			if (assetIndex == -1)
			{
				assetIndex = _effectsAssets.getItemIndex(asset);
			}
			return assetIndex;
		}

		/**
		 * gets the relavent arrayCollection by the timeline type.
		 * @param timeline_type		the timeline type.
		 * @return 					the arraycollection of this timeline.
		 * @see com.kaltura.roughcut.assets.TimelineTypes
		 */
		public function getTimelineByType (timeline_type:uint):ArrayCollection
		{
			var retval:ArrayCollection = null;
			switch (timeline_type)
			{
				case TimelineTypes.VIDEO:
					retval = _videoAssets;
				break;
				case TimelineTypes.AUDIO:
					retval = _audioAssets;
				break;
				case TimelineTypes.OVERLAYS:
					retval = _overlaysAssets;
				break;
				case TimelineTypes.EFFECTS:
					retval = _effectsAssets;
				break;
			}
			return retval;
		}

		/**
		 * get the timeline by an asset it contains.
		 * @param asset		the asset whos timeline to get.
		 * @return 			array with the timeline of the given asset, the timeline type and the asset index in the timeline,
		 * 					null if the asset is not member of this roughcut.
		 */
		public function getTimelineByAsset (asset:AbstractAsset):Array
		{
			var assetIndex:int = _videoAssets.getItemIndex(asset);
			var timeline:ArrayCollection = _videoAssets;
			var timelineType:uint = TimelineTypes.VIDEO;
			if (assetIndex == -1)
			{
				assetIndex = _audioAssets.getItemIndex(asset);
				timeline = _audioAssets;
				timelineType = TimelineTypes.AUDIO;
			}
			if (assetIndex == -1)
			{
				assetIndex = _overlaysAssets.getItemIndex(asset);
				timeline = _overlaysAssets;
				timelineType = TimelineTypes.OVERLAYS;
			}
			if (assetIndex == -1)
			{
				assetIndex = _effectsAssets.getItemIndex(asset);
				timeline = _effectsAssets;
				timelineType = TimelineTypes.EFFECTS;
			}
			if (assetIndex == -1)
				timeline = null;
			return [timeline, timelineType, assetIndex];
		}

		//==========================================================================================
		/**
		 *loads all the mediaSource objects of the assets in the timelines (ExNetStreams, Images, plugoins...).
		 * @param types							the types of timelines to load, as defined by LoadMediaSourceType.
		 * @param streamingMode			determine the serving method used to get the media files.
         * @see com.kaltura.managers.downloadManagers.types.StreamingModes
		 * @see com.kaltura.roughcut.assets.LoadMediaSourceType
		 * @see com.kaltura.managers.downloadManagers.DownloadManager
		 */
		public function loadAssetsMediaSources (types:int, streamingMode:int = 0):void
		{
			var asset:AbstractAsset;
			var i:int = 0;
			var N:int;
			//load video timeline
			if (types & TimelineTypes.VIDEO)
			{
				N =  _videoAssets.length;
				for ( ; i < N ; ++i)
				{
					asset = _videoAssets.getItemAt(i) as AbstractAsset;
					if (asset.mediaType == MediaTypes.VIDEO && streamingMode == StreamingModes.BITMAP_SOCKET)
						asset.mediaType = MediaTypes.BITMAP_SOCKET;
					if (i == 0)
					{
						switch (asset.mediaType)
						{
							case MediaTypes.VIDEO:
								dManager.loadAsset (roughcutEntryId, roughcutEntryVersion, asset, null, streamingMode, i);
								if (asset.mediaSourceLoader.status == LoadingStatus.COMPLETE)
									dispatchFirstFrameLoaded();
								else
									asset.mediaSourceLoader.addEventListener(ProgressEvent.PROGRESS, dispatchFirstFrameLoaded);
								break;

							case MediaTypes.IMAGE:
							case MediaTypes.SWF:
							case MediaTypes.BITMAP_SOCKET:
								dManager.loadAsset (roughcutEntryId, roughcutEntryVersion, asset, dispatchFirstFrameLoaded, streamingMode, i);
								break;

							default:
								doFirstFrame = true;
						}
					} else {
						switch (asset.mediaType)
						{
							case MediaTypes.VIDEO:
							case MediaTypes.IMAGE:
							case MediaTypes.SWF:
							case MediaTypes.BITMAP_SOCKET:
								dManager.loadAsset (roughcutEntryId, roughcutEntryVersion, asset, null, streamingMode, i);
								break;
						}
					}
					if (types & TimelineTypes.TRANSITIONS)
					{
						if (asset.transitionPluginID != TransitionTypes.NONE)
						{
							var transitionAsset:AbstractAsset = AssetsFactory.create (MediaTypes.TRANSITION, asset.assetUID, '0',
												asset.entryName + ".AssetTransition", KalturaApplication.getInstance().getTransitionThumbnail(asset.transitionPluginID), asset.transitionPluginID,
												asset.transitionLength, asset.transitionLength, 0, 0, asset.transitionPluginID, asset.transitionLength);
							asset.transitionAsset = transitionAsset;
							asset.transitionAsset.transitionCross = asset.transitionCross;
							transitionAsset.pluginAssetXml = asset.pluginAssetXml;
							dManager.loadAsset (roughcutEntryId, roughcutEntryVersion, transitionAsset);
						}
					}
				}
			}
			if (types & TimelineTypes.AUDIO)
			{
				//load audio timeline
				N =  _audioAssets.length;
				for (i = 0 ; i < N ; ++i)
				{
					asset = _audioAssets.getItemAt(i) as AbstractAsset;
					if (asset.mediaType == MediaTypes.AUDIO)
						dManager.loadAsset (roughcutEntryId, roughcutEntryVersion, asset, null, streamingMode, i);
				}
			}
			if (types & TimelineTypes.OVERLAYS)
			{
				//load overlays timeline plugins
				N =  _overlaysAssets.length;
				for (i = 0 ; i < N ; ++i)
				{
					asset = _overlaysAssets.getItemAt(i) as AbstractAsset;
					dManager.loadAsset (roughcutEntryId, roughcutEntryVersion, asset);
				}
			}
			if (types & TimelineTypes.EFFECTS)
			{
				//load effects timeline plugins
				N =  _effectsAssets.length;
				for (i = 0 ; i < N ; ++i)
				{
					asset = _effectsAssets.getItemAt(i) as AbstractAsset;
					dManager.loadAsset (roughcutEntryId, roughcutEntryVersion, asset);
				}
			}
			buildRoughcutAssets();
			finishedLoadingProcess = true;
			if (doFirstFrame == true)
				dispatchEvent(new RoughcutStatusEvent (RoughcutStatusEvent.FIRST_FRAME_LOADED));
		}

		/**
		 * track the loading of an asset.
		 * @param event		the event that IMediaSourceLoader dispatches.
		 * @see com.kaltura.managers.downloadManagers.protocols.loaders.events.MediaSourceLoaderEvent
		 */
		protected function assetCompleteLoading (event:DownloadManagerStatusEvent):void
		{
			if (event.roughcutEntryId == roughcutEntryId && event.roughcutEntryVersion == roughcutEntryVersion)
			{
				trace (event.url + " finished download.");
				dispatchEvent(new RoughcutChangeEvent (RoughcutChangeEvent.ROUGHCUT_DIRTY));
			}
		}

		/**
		 *when the first asset has enough data to show the first frame of the roughcut, dispatch a firstFrameLoaded status event.
		 * <p>when loading a roughcut to the player, use this event to determine when the player is ready for the first seek.</p>
		 */
		protected function dispatchFirstFrameLoaded (event:Event = null):void
		{
			doFirstFrame = true;
			if (finishedLoadingProcess)
				dispatchEvent(new RoughcutStatusEvent (RoughcutStatusEvent.FIRST_FRAME_LOADED));
			if (event)
				IEventDispatcher(event.target).removeEventListener (event.type, dispatchFirstFrameLoaded);
		}

		//==========================================================================================
		/**
		 * provides access to the video timeline assets.
		 * @return 		array that holds references to the assets on the video timeline.
		 */
		[Bindable (event="roughcutDirty")]
		public function get videoAssets  ():ArrayCollection
		{
			return _videoAssets;
		}

		/**
		 * provides access to the audio timeline assets.
		 * @return 		array that holds references to the assets on the audio timeline.
		 */
		[Inspectable]
		[Bindable (event="roughcutDirty")]
		public function get audioAssets ():ArrayCollection
		{
			return _audioAssets;
		}

		/**
		 * provides access to the overlays timeline assets.
		 * @return 		array that holds references to the assets on the overlays timeline.
		 */
		[Inspectable]
		[Bindable (event="roughcutDirty")]
		public function get overlaysAssets ():ArrayCollection
		{
			return _overlaysAssets;
		}

		/**
		 * provides access to the effects timeline assets.
		 * @return 		array that holds references to the assets on the effects timeline.
		 */
		[Inspectable]
		[Bindable (event="roughcutDirty")]
		public function get effectsAssets ():ArrayCollection
		{
			return _effectsAssets;
		}

		/**
		 *disposes of the object and its members.
		 */
		public function dispose ():void
		{
			clearTimeline (TimelineTypes.ANY_TIMELINE);
			_videoAssets = null;
			_audioAssets = null;
			_overlaysAssets = null;
			_effectsAssets = null;
			if (soundtrackAsset) {
				dManager.removeAssetLoader(roughcutEntryId, roughcutEntryVersion, soundtrackAsset.assetUID);
				soundtrackAsset.dispose();
			}
			soundtrackAsset = null;
		}
		//==========================================================================================

		/**
		 *clears the timelines.
		 * @param timeline		the timelines to clear, pass bitmask according to TimelineTypes.
		 * @see com.kaltura.roughcut.assets.TimelineTypes
		 */
		public function clearTimeline (timeline:uint):void
		{
			var disposeFunction:Function = function (dispObj:IDisposable, index:int, arr:Array):void
											{
												var asset:AbstractAsset = dispObj as AbstractAsset;
												dManager.removeAssetLoader(roughcutEntryId, roughcutEntryVersion, asset.assetUID);
												asset.dispose();
											};
			// clear video timeline
			if (timeline & TimelineTypes.VIDEO && !(timeline & TimelineTypes.TRANSITIONS))
			{
				_videoAssets.source.forEach (disposeFunction, null);
				_videoAssets.removeAll();
			}
			//clear audio timeline
			if (timeline & TimelineTypes.AUDIO && !(timeline & TimelineTypes.TRANSITIONS))
			{
				soundtrackAsset = null;
				_audioAssets.source.forEach (disposeFunction, null);
				_audioAssets.removeAll();
				dispatchEvent(new RoughcutChangeEvent (RoughcutChangeEvent.ROUGHCUT_SOUNDTRACK_CHANGE));
			}
			//clear transitions from timelines
			if (timeline & TimelineTypes.TRANSITIONS)
			{
				var clearTransitionsFunc:Function = function (asset:AbstractAsset, index:int, arr:Array):void
													{
														asset.transitionAsset = null;
														asset.transitionPluginID = TransitionTypes.NONE;
														asset.transitionLength = 0;
													};
				// clear transitions from video timeline
				if (timeline & TimelineTypes.VIDEO)
				{
					_videoAssets.source.forEach (clearTransitionsFunc, null);
				}
				// clear transitions from audio timeline
				if (timeline & TimelineTypes.AUDIO)
				{
					_audioAssets.source.forEach (clearTransitionsFunc, null);
				}
			}
			// clear overlays
			if (timeline & TimelineTypes.OVERLAYS)
			{
				_overlaysAssets.removeAll();
			}
			// clear effects
			if (timeline & TimelineTypes.EFFECTS)
			{
				_effectsAssets.removeAll();
			}
			dispatchEvent(new RoughcutChangeEvent (RoughcutChangeEvent.ROUGHCUT_DIRTY));
		}

		/**
		 *removes a specific asset from the selected timeline.
		 * @param asset_index		the index of the asset in the timeline.
		 * @param timeline			the timeline of the asset.
		 */
		public function removeAsset (asset_index:uint, timeline:uint = 0x2):void
		{
			var disposeAsset:Function = function (index:uint, array:ArrayCollection):void
								{
									var asset:AbstractAsset = array.getItemAt(index) as AbstractAsset;
									dManager.removeAssetLoader(roughcutEntryId, roughcutEntryVersion, asset.assetUID);
									asset.dispose();
									array.removeItemAt(index);
								}
			if (timeline & TimelineTypes.VIDEO)
			{
				disposeAsset (asset_index, _videoAssets);
			}
			if (timeline & TimelineTypes.AUDIO)
			{
				disposeAsset (asset_index, _audioAssets);
			}
			if (timeline & TimelineTypes.EFFECTS)
			{
				disposeAsset (asset_index, _effectsAssets);
			}
			if (timeline & TimelineTypes.OVERLAYS)
			{
				disposeAsset (asset_index, _overlaysAssets);
			}
			buildRoughcutAssets ();
		}

		/**
		 *removes the transition from the asset or group of assets specified.
		 * @param timeline			the timeline the asset is in.
		 * @param clear_all			pass true to clear the transitions from all assets of the timeline.
		 * @param asset_index		the index of the asset to remove it's transition.
		 * @param assets_indices		a list of assets indexs to remove transitions for.
		 */
		public function removeTransitions (timeline:uint = 0x2, clear_all:Boolean = true, asset_index:int = -1, ...assets_indices):void
		{
			if (clear_all)
			{	// clear all transitions on the given timeline
				clearTimeline (timeline | TimelineTypes.TRANSITIONS);
				return;
			}
			var asset:AbstractAsset;
			var removeTransitionFunc:Function = function (asset2clear:AbstractAsset):void
											{
												if (asset)
												{
													asset2clear.transitionAsset = null;
													asset2clear.transitionPluginID = TransitionTypes.NONE;
													asset2clear.transitionLength = 0;
												}
											}
			if (asset_index >= 0)
			{
				asset = (timeline & TimelineTypes.VIDEO) ? _videoAssets.getItemAt(i) as AbstractAsset :
						(timeline & TimelineTypes.AUDIO) ? _audioAssets.getItemAt(i) as AbstractAsset : null;
				removeTransitionFunc (asset);
			}
			if (assets_indices.length > 0)
			{
				var i:int = 0;
				for ( ; i < assets_indices.length; ++i)
				{
					asset = (timeline & TimelineTypes.VIDEO) ? _videoAssets.getItemAt(i) as AbstractAsset :
							(timeline & TimelineTypes.AUDIO) ? _audioAssets.getItemAt(i) as AbstractAsset : null;
					removeTransitionFunc (asset);
				}
			}
			buildRoughcutAssets ();
		}

		/**
		 *adds a new asset to a specific timeline and loads it's media source.
		 * @param asset				the asset to add.
		 * @param asset_index		the index in the timeline to add the asset at.
		 * @param timeline			the timeline to add the asset to.
		 * @param load_asset		true to load the asset's media source.
		 * @return 					the new asset's index.
		 * @see com.kaltura.assets.abstracts.AbstractAsset
		 */
		public function addAsset (asset:AbstractAsset, asset_index:int, timeline:uint, load_asset:Boolean = true):int
		{
			var addIndex:int;
			// add to video timeline
			if (timeline & TimelineTypes.VIDEO)
			{
				addIndex = Math.max(0, Math.min(_videoAssets.length, asset_index));
				_videoAssets.addItemAt (asset, addIndex);
			}
			// add to audio timeline
			if (timeline & TimelineTypes.AUDIO)
			{
				addIndex = Math.max(0, Math.min(_audioAssets.length, asset_index));
				// make sure that dragged video item will be transformed to audio:
				if (asset.mediaType != MediaTypes.SILENCE)
					asset.mediaType = MediaTypes.AUDIO;
				_audioAssets.addItemAt (asset, addIndex);
			}
			// add a new plugin
			if (asset is PluginAsset)
			{
				// add new effect
				if (timeline & TimelineTypes.EFFECTS)
				{
					addIndex = Math.max(0, Math.min(_effectsAssets.length, asset_index));
					_effectsAssets.addItemAt (asset, addIndex);
				}
				// add new overlay
				if (timeline & TimelineTypes.OVERLAYS)
				{
					addIndex = Math.max(0, Math.min(_overlaysAssets.length, asset_index));
					_overlaysAssets.addItemAt (asset, addIndex );
				}
			}
			if (load_asset)
				dManager.loadAsset (roughcutEntryId, roughcutEntryVersion, asset);
			buildRoughcutAssets ();
			return addIndex;
		}

		/**
		 *changes the asset position in the timeline (changes the index in the relavent timeline array).
		 * <p>if the index doesn't exist, nothing will happen.
		 * if the new index is negative, the asset will be set to index 0.
		 * if the new index is larger than the total number of assets in the timeline, the asset will be set to be last.</p>
		 * @param timeline				the relavent timelines (operation can be preformed on multipal timelines).
		 * @param asset_index			the position of the asset in the timeline to change.
		 * @param new_asset_index		the new position (array index) in the timeline.
		 * @param number_of_items		the number of items to move (to move multipal items).
		 */
		public function moveAsset (timeline:uint, asset_index:uint, new_asset_index:uint, number_of_items:uint = 1):void
		{
			var changeItemIndex:Function = function (asset_index:uint, new_asset_index:uint, assets_array:ArrayCollection, ammount:uint = 1):void
						{
							if (asset_index > -1 && asset_index < assets_array.length)
							{
								if (new_asset_index > -1)
								{
									if (new_asset_index > assets_array.length)
									{
										new_asset_index = assets_array.length;
									}
									var item:Object;
									for (var i:int = ammount - 1; i > -1; --i)
									{
										item = assets_array.removeItemAt(asset_index + i);
										assets_array.addItemAt(item, new_asset_index);
									}
									//var asset2move:Array = assets_array.splice (asset_index, ammount);
									//assets_array.splice (new_asset_index, 0, asset2move.length > 1 ? asset2move : asset2move[0]);
								}
							}
						}
			if (timeline & TimelineTypes.VIDEO)
			{
				changeItemIndex (asset_index, new_asset_index, _videoAssets, number_of_items);
			}
			if (timeline & TimelineTypes.AUDIO)
			{
				changeItemIndex (asset_index, new_asset_index, _audioAssets, number_of_items);
			}
			if (timeline & TimelineTypes.TRANSITIONS)
			{
				//TODO: move transition
			}
			buildRoughcutAssets ();
		}

		/**
		 *adds a transition to specified asset.
		 * @param transition_type		the TransitionType of the transition to add.
		 * @param transition_duration	the length of the transition.
		 * @param asset_index			the index of the asset to which to add the transition.
		 * @param timeline				the timeline of the asset.
		 * @param cross					does this transition perfoms cross between two assets, or just switch between current and next ?
		 */
		public function addAssetTransition (transition_type:String, transition_duration:Number, asset_index:uint, timeline:uint = 0x2, cross:Boolean = false):void
		{
			if (timeline & TimelineTypes.VIDEO)
			{
				var transitionAsset:AbstractAsset;
				var asset:AbstractAsset = _videoAssets.getItemAt(asset_index) as AbstractAsset;
				asset.transitionPluginID = transition_type;
				asset.transitionCross = cross;
				asset.transitionLabel = KalturaApplication.getInstance().getTransitionLabel(asset.transitionPluginID);
				asset.transitionLength = (transition_type != TransitionTypes.NONE) ? transition_duration : 0;
				transitionAsset = AssetsFactory.create (MediaTypes.TRANSITION, "null", '0',
										asset.entryName + ".AssetTransition", KalturaApplication.getInstance().getTransitionThumbnail(asset.transitionPluginID), asset.transitionPluginID,
										asset.transitionLength, asset.transitionLength, 0, 0, asset.transitionPluginID, asset.transitionLength);
				asset.transitionAsset = transitionAsset;
				asset.transitionAsset.transitionCross = asset.transitionCross;
				if (transition_type != TransitionTypes.NONE)
					dManager.loadAsset (roughcutEntryId, roughcutEntryVersion, transitionAsset);
				//xxx asset.dispatchEvent(PropertyChangeEvent.createUpdateEvent(asset, "transitionThumbnail", "", asset.transitionThumbnail));
				buildRoughcutAssets ();
			}
		}

		/**
		 *adds a plugin at a given time stamp in the roughcut (plugin can be either an overlay, text overlay or an effect).
		 * @param plugin			the plugin info that describe the plugin to add.
		 * @param time_stamp		the time to add this plugin at.
		 * @param length_sec		the length in seconds for the new plugin.
		 * @param timeline			the timeline this plugin should be added to.
		 * @return 					the index of the new item.
		 */
		public function addPlugin (plugin:KalturaPluginInfo, time_stamp:Number, length_sec:Number, timeline:uint = 0x2):uint
		{
			if (timeline & TimelineTypes.VIDEO)
			{
				var pluginAsset:AbstractAsset;
				pluginAsset = AssetsFactory.create (plugin.mediaType, "null", '0',
										plugin.label, KalturaApplication.getInstance().getPluginThumbnail(plugin.pluginId, plugin.mediaType),
										plugin.pluginId, length_sec, Number.MAX_VALUE, time_stamp, 0, TransitionTypes.NONE, 0);
				pluginAsset.seqStartPlayTime = time_stamp;
				pluginAsset.seqEndPlayTime = time_stamp + length_sec;
				dManager.loadAsset (roughcutEntryId, roughcutEntryVersion, pluginAsset);
				if (plugin.mediaType & MediaTypes.EFFECT)
					effectsAssets.addItem(pluginAsset);
				else
					overlaysAssets.addItem(pluginAsset);
				buildRoughcutAssets ();
				if (plugin.mediaType & MediaTypes.EFFECT)
					return effectsAssets.length-1;
				else
					return overlaysAssets.length-1;
			}
			return 0;
		}

		/**
		 *change the start time of specific asset.
		 * @param timeline			the timeline in which the asset is.
		 * @param asset_index		the index of the asset in the timeline.
		 * @param start_time		the new start time value.
		 */
		public function setAssetStartTime (timeline:uint, asset_index:uint, start_time:Number):void
		{
			var changeStartTime:Function = function (timeline:ArrayCollection, index_of_asset:uint, asset_start:Number):void
						{
							var asset:AbstractAsset;
							if (index_of_asset >= timeline.length)
								return;
							asset = timeline.getItemAt(index_of_asset) as AbstractAsset;
							var typesCheck:uint = MediaTypes.EFFECT | MediaTypes.OVERLAY;
							if (asset.mediaType & typesCheck)
							{
								asset.startTime = (asset_start > 0 && asset_start < roughcutDuration) ? asset_start : asset.startTime;
							} else {
								var asset_end:Number = asset.length + asset.startTime;
								var newLength:Number = asset_end - asset_start;
								if (newLength > asset.transitionLength)
								{
									asset.startTime = asset_start;
									asset.length = newLength;
								}
							}
						}
			var asset:AbstractAsset;
			if (timeline & TimelineTypes.VIDEO)
			{
				changeStartTime (_videoAssets, asset_index, start_time);
			}
			if (timeline & TimelineTypes.AUDIO)
			{
				changeStartTime (_audioAssets, asset_index, start_time);
			}
			if (timeline & TimelineTypes.EFFECTS)
			{
				changeStartTime (_effectsAssets, asset_index, start_time);
			}
			if (timeline & TimelineTypes.OVERLAYS)
			{
				changeStartTime (_overlaysAssets, asset_index, start_time);
			}
			buildRoughcutAssets ();
		}

		/**
		 *changes duration for specific assets.
		 * @param timelines			the timelines in which the assets are.
		 * @param asset_index		the index of the asset in the timeline.
		 * @param duration			the new duration to set.
		 * @param assets_indices	array of indexs for changing multipal assets.
		 */
		public function setAssetDuration (timelines:uint, asset_index:uint, duration:Number, assets_indices:Array = null):void
		{
			var changeDuration:Function = function (timeline:ArrayCollection, asset_duration:Number, indices:Array):void
										{
											var i:int = 0;
											var N:int = indices.length;
											var asset:AbstractAsset;
											for ( ; i < N; ++i)
											{
												if (indices[i] >= timeline.length)
													continue;
												asset = timeline.getItemAt(indices[i]) as AbstractAsset;
												var typesCheck:uint = MediaTypes.IMAGE | MediaTypes.SOLID | MediaTypes.SILENCE;
												if (asset.mediaType & typesCheck)
												{
													// set duration for Images, solid and silence
													asset.length = asset_duration > (asset.transitionCross ? (asset.transitionLength / 2) : asset.transitionLength) ?
																asset_duration : asset.length;
												} else {
													typesCheck = MediaTypes.EFFECT | MediaTypes.OVERLAY;
													if (asset.mediaType & typesCheck)
													{
														// set duration for effects and overlays
														asset.length = (asset_duration > 0 && asset_duration < roughcutDuration) ? asset_duration : asset.length;
													} else {
														// set duration for video or audio streams
														asset.length = (asset_duration <= asset.maxLength - asset.startTime) && (asset_duration >
																(asset.transitionCross ? (asset.transitionLength / 2) : asset.transitionLength)) ?
																asset_duration : asset.length;
													}
												}
											}
										}
			if (!assets_indices)
				assets_indices = [];
			var asset:AbstractAsset;
			if (timelines & TimelineTypes.VIDEO)
			{
				assets_indices.push (asset_index);
				changeDuration (_videoAssets, duration, assets_indices);
			}
			if (timelines & TimelineTypes.AUDIO)
			{
				assets_indices.push (asset_index);
				changeDuration (_audioAssets, duration, assets_indices);
			}
			if (timelines & TimelineTypes.EFFECTS)
			{
				assets_indices.push (asset_index);
				changeDuration (_effectsAssets, duration, assets_indices);
			}
			if (timelines & TimelineTypes.OVERLAYS)
			{
				assets_indices.push (asset_index);
				changeDuration (_overlaysAssets, duration, assets_indices);
			}
			buildRoughcutAssets ();
		}

		/**
		 *changes volume for specific assets.
		 * @param timelines			the timelines in which the assets are.
		 * @param asset_index		the index of the asset in the timeline.
		 * @param volume			the new volume to set.
		 * @param assets_indices	array of indexs for changing multipal assets.
		 */
		public function setAssetVolume (timelines:uint, asset_index:uint, volume:Number, assets_indices:Array = null):void
		{
			var changeVolume:Function = function (timeline:ArrayCollection, asset_volume:Number, indices:Array):void
										{
											var i:int = 0;
											var N:int = indices.length;
											var asset:AbstractAsset;
											for ( ; i < N; ++i)
											{
												asset = timeline.getItemAt(indices[i]) as AbstractAsset;
												asset.audioGraph.setOverallVolume(asset_volume);
											}
										}
			if (!assets_indices)
				assets_indices = [];
			var asset:AbstractAsset;
			if (timelines & TimelineTypes.VIDEO)
			{
				assets_indices.push (asset_index);
				changeVolume (_videoAssets, volume, assets_indices);
			}
			if (timelines & TimelineTypes.AUDIO)
			{
				assets_indices.push (asset_index);
				changeVolume (_videoAssets, volume, assets_indices);
			}
			if (timelines & TimelineTypes.EFFECTS)
			{
				assets_indices.push (asset_index);
				changeVolume (_videoAssets, volume, assets_indices);
			}
			if (timelines & TimelineTypes.OVERLAYS)
			{
				assets_indices.push (asset_index);
				changeVolume (_videoAssets, volume, assets_indices);
			}
			buildRoughcutAssets ();
		}

		/**
		 *changes balance for specific assets.
		 * @param timelines			the timelines in which the assets are.
		 * @param asset_index		the index of the asset in the timeline.
		 * @param balance			the new balance to set.
		 * @param assets_indices	array of indexs for changing multipal assets.
		 */
		public function setAssetBalance (timelines:uint, asset_index:uint, balance:Number, assets_indices:Array = null):void
		{
			var changeBalance:Function = function (timeline:ArrayCollection, asset_balance:Number, indices:Array):void
										{
											var i:int = 0;
											var N:int = indices.length;
											var asset:AbstractAsset;
											for ( ; i < N; ++i)
											{
												asset = timeline.getItemAt(indices[i]) as AbstractAsset;
												asset.audioBalance = asset_balance;
											}
										}
			if (!assets_indices)
				assets_indices = [];
			var asset:AbstractAsset;
			if (timelines & TimelineTypes.VIDEO)
			{
				assets_indices.push (asset_index);
				changeBalance (_videoAssets, balance, assets_indices);
			}
			if (timelines & TimelineTypes.AUDIO)
			{
				assets_indices.push (asset_index);
				changeBalance (_videoAssets, balance, assets_indices);
			}
			if (timelines & TimelineTypes.EFFECTS)
			{
				assets_indices.push (asset_index);
				changeBalance (_videoAssets, balance, assets_indices);
			}
			if (timelines & TimelineTypes.OVERLAYS)
			{
				assets_indices.push (asset_index);
				changeBalance (_videoAssets, balance, assets_indices);
			}
			buildRoughcutAssets ();
		}

		/**
		 *duplicates a given asset.
		 * @param target_asset		the asset to duplicate.
		 * @param load_asset		true to load the new asset's media source.
		 * @return 					the new duplicated asset.
		 *
		 */
		public function duplicateAsset (target_asset:AbstractAsset, load_asset:Boolean = true):AbstractAsset
		{
			var newAsset:AbstractAsset;
			newAsset = target_asset.clone();
			if (load_asset)
				dManager.loadAsset (roughcutEntryId, roughcutEntryVersion, newAsset);
			return newAsset;
		}

		/**
		 *splits an asset to two different assets in a given time.
		 * <p>note that the given time should relative to the asset itself, not a roughcut time.</p>
		 * @param target_asset		the asset to split into two.
		 * @param time_to_split		the time to split the asset at, this should be relative to the asset's time.
		 */
		public function spliteAsset (target_asset:AbstractAsset, time_to_split:Number):void
		{
			if (target_asset.length <= time_to_split)
			{
				//throw new Error ("can't split an asset on time larger or eaual to it's duration");
				return;
			}
			var newAsset:AbstractAsset = duplicateAsset (target_asset, false);
			var newDuration:Number = target_asset.length - time_to_split;
			if (newAsset.mediaType & (MediaTypes.AUDIO | MediaTypes.VIDEO | MediaTypes.BITMAP_SOCKET))
				newAsset.startTime = target_asset.startTime + time_to_split;
			newAsset.length = newDuration;
			target_asset.length = time_to_split;
			var gettimelineresult:Array = getTimelineByAsset(target_asset);
			var timeline:ArrayCollection = gettimelineresult[0];
			var timelineType:uint = gettimelineresult[1];
			var assetIndex:int = gettimelineresult[2];
			addAsset(newAsset, assetIndex + 1, timelineType);
			resetStreamingAsset (newAsset);
		}

		/**
		 *resets a streaming type asset (audio/video) to load the full stream instead of the clipped part.
		 * @param asset		the asset to reset.
		 */
		public function resetStreamingAsset (asset:AbstractAsset):void
		{
			if (asset && (asset.mediaType & (MediaTypes.AUDIO | MediaTypes.VIDEO)))
			{
				asset.clipedStreamStart = 0;
				asset.clipedStreamLen = asset.maxLength;
				var partnerInfo:PartnerInfo = KalturaApplication.getInstance().partnerInfo;
				var pId:String = partnerInfo == null ? '-1' : partnerInfo.partnerId;
				var subpId:String = partnerInfo == null ? '-1' : partnerInfo.subpId;
				var partnerPart:String = URLProccessing.getPartnerPartForTracking(pId, subpId);
				var url2Load:String = URLProccessing.clipperServiceUrl (asset.entryId, -1, -1, '0', partnerPart);
				asset.mediaURL = URLProccessing.hashURLforMultipalDomains (url2Load, asset.entryId);
				var netstream:ExNetStream = asset.mediaSource as ExNetStream;
				if (netstream)
				{
					netstream.changeStreamURL ( asset.mediaURL );
					asset.mediaSourceLoader.reload ();
				}
			}
		}

		/**
		 *trim a specific asset, changes the duration and the start time of the asset.
		 * @param timeline			the timeline in which the asset is.
		 * @param asset_index		the index of the asset in the timeline.
		 * @param start_time		the new start time value.
		 * @param duration			the new duration value.
		 */
		public function trimAsset (timeline:uint, asset_index:uint, start_time:Number, duration:Number):void
		{
			var asset:AbstractAsset;
			if (timeline & TimelineTypes.VIDEO)
			{
				//it's video:
				if (asset_index >= _videoAssets.length)
					return;
				asset = _videoAssets.getItemAt(asset_index) as AbstractAsset;
				if (asset.mediaType == MediaTypes.VIDEO)
				{
					var ns:ExNetStream = asset.mediaSource;
					if (ns)
					{
						var nclient:NetClient = ns.client as NetClient;
						if (nclient && nclient.metaData)
						{
							//fix the trim to keyframes:
							var smd:StreamMetaData = nclient.metaData;
							var seekResult:Array;
							if (start_time >= 0)
							{
								seekResult = smd.seekToPreciseKeyframe(start_time, asset.clipedStreamStart, start_time > asset.startTime);
								var newStart:Number = seekResult[0];
								var firstKf:Number = -1;
								if (smd.times != null && smd.times.length > 0)
									firstKf = smd.times[0] / 1000;
								if (start_time < firstKf)
									newStart = 0;
								var diff:Number = newStart - asset.startTime;
								asset.startTime = newStart;
								var len:Number = asset.length - diff;
								asset.length = len;
							}
							if (duration >= 0)
							{
								var end:Number = asset.startTime + duration;
								seekResult = smd.seekToPreciseKeyframe(end, asset.clipedStreamStart, true);
								var newEnd:Number = seekResult[0];
								var lastKf:Number = Number.POSITIVE_INFINITY;
								if (smd.times != null && smd.times.length > 0)
									lastKf = smd.times[smd.times.length-1] / 1000;
								if (end >= lastKf)
									newEnd = asset.maxLength;
								asset.length = newEnd - asset.startTime;//((newEnd * 10000 - asset.startTime * 10000) >>> 0) / 10000;
							}
						} else {
							if (start_time >= 0)
								asset.startTime = start_time;
							if (duration >= 0)
								asset.length = duration;
						}
					}
				} else {
					//it's a non-streaming content (image, solid...)
					if (duration >= 0)
						asset.length = duration;
				}
			}
			if (timeline & TimelineTypes.AUDIO)
			{
				if (asset_index >= _audioAssets.length)
					return;
				asset = _audioAssets.getItemAt(asset_index) as AbstractAsset;
				if (asset.mediaType == MediaTypes.AUDIO)
				{
					//it's audio:
					if (start_time >= 0)
						asset.startTime = start_time;
					if (duration >= 0)
						asset.length = duration;
				} else {
					//it's silence:
					if (duration >= 0)
						asset.length = duration;
				}
			}
			if (timeline & (TimelineTypes.OVERLAYS | TimelineTypes.EFFECTS))
			{
				var timelineArray:ArrayCollection = getTimelineByType(timeline);
				asset = timelineArray.getItemAt(asset_index) as AbstractAsset;
				if (start_time >= 0)
					asset.seqStartPlayTime = start_time;
				if (duration >= 0)
					asset.length = duration;
			}
			buildRoughcutAssets ();
		}

		/**
		 *changes duration for specific asset's transition.
		 * @param timeline			the timeline in which the asset is.
		 * @param asset_index		the index of the asset in the timeline.
		 * @param duration			the new duration to set.
		 */
		public function setTransitionDuration (timeline:uint, asset_index:uint, duration:Number):void
		{
			var asset:AbstractAsset;
			if (timeline & TimelineTypes.VIDEO)
			{
				asset = _videoAssets.getItemAt(asset_index) as AbstractAsset;
				asset.transitionLength = duration;
				if (asset.transitionAsset)
				{
					asset.transitionAsset.maxLength = duration;
					asset.transitionAsset.length = duration;
					asset.transitionAsset.transitionLength = duration;
				}
			}
			if (timeline & TimelineTypes.AUDIO)
			{
				asset = _audioAssets.getItemAt(asset_index) as AbstractAsset;
				asset.transitionLength = duration;
				if (asset.transitionAsset)
				{
					asset.transitionAsset.maxLength = duration;
					asset.transitionAsset.length = duration;
					asset.transitionAsset.transitionLength = duration;
				}
			}
			buildRoughcutAssets ();
		}

		/**
		 *refreshes arrayCollections of the requested timelines.
		 * @param timelines		the timelines to refresh.
		 * @see com.kaltura.roughcut.assets.TimelineTypes
		 */
		public function refreshTimelines (timelines:uint):void
		{
/*xxx 			if (timelines & TimelineTypes.AUDIO)
				_audioAssets.refresh();
			if (timelines & TimelineTypes.VIDEO)
				_videoAssets.refresh();
			if (timelines & TimelineTypes.EFFECTS)
				_effectsAssets.refresh();
			if (timelines & TimelineTypes.OVERLAYS)
				_overlaysAssets.refresh();
 */		}

		// =================================================================================
		// Overall functions:

		/**
		 *sets a desired duration on all assets of the timelines.
		 * @param timelines			the timelines to set duration of assets to.
		 * @param media_types		the media types of the assets to change (ie. change only images).
		 * @param duration			the desired duration.
		 * @see com.kaltura.roughcut.assets.TimelineTypes
		 * @see com.kaltura.common.types.MediaTypes
		 */
		public function setAllAssetsDuration (timelines:uint, media_types:uint, duration:Number):void
		{
			var setDuration:Function = function (asset:AbstractAsset, duration:uint, media_types:uint):void
								{
									if (asset.mediaType & media_types)
									{
										if (asset.mediaType != MediaTypes.VIDEO && asset.mediaType != MediaTypes.AUDIO)
										{
											asset.length = duration;
										} else {
											asset.length = duration <= (asset.maxLength - asset.startTime) ? duration : asset.length;
										}
									}
								}
			var asset:AbstractAsset;
			var i:int;
			if (timelines & TimelineTypes.VIDEO)
			{
				for (i = 0; i < _videoAssets.length; ++i)
				{
					asset = _videoAssets.getItemAt(i) as AbstractAsset;
					setDuration (asset, media_types, duration);
				}
			}
			if (timelines & TimelineTypes.AUDIO)
			{
				for (i = 0; i < _audioAssets.length; ++i)
				{
					asset = _audioAssets.getItemAt(i) as AbstractAsset;
					setDuration (asset, media_types, duration);
				}
			}
			buildRoughcutAssets ();
		}

		/**
		 *sets a desired transition type on all assets of video timeline.
		 * @param media_types			the media types of the assets to set transition to (ie, set only images).
		 * @param transition_type		the type of the transition to set.
		 * @param transition_duration	the duration of the transition.
		 * @see com.kaltura.plugin.types.transitions.transitionPluginIDs
		 */
		public function setAllAssetsTransition (media_types:uint, transition_type:String, transition_duration:Number):void
		{
			var asset:AbstractAsset;
			var transitionAsset:AbstractAsset;
			var i:int;
			for (i = 0; i < _videoAssets.length; ++i)
			{
				asset = _videoAssets.getItemAt(i) as AbstractAsset;
				asset.transitionPluginID = transition_type;
				asset.transitionLength = asset.length > transition_duration * 2 ? transition_duration : asset.length - 0.1;
				transitionAsset = AssetsFactory.create (MediaTypes.TRANSITION, asset.assetUID, '0',
									asset.entryName + ".AssetTransition", asset.transitionPluginID, asset.transitionPluginID,
									asset.transitionLength, asset.transitionLength, 0, 0, asset.transitionPluginID, asset.transitionLength);
				asset.transitionAsset = transitionAsset;
				dManager.loadAsset (roughcutEntryId, roughcutEntryVersion, transitionAsset);
			}
			buildRoughcutAssets ();
		}

		/**
		 *sets a desired volume to all assets of the timeline.
		 * @param timelines			the timelines to sets volume to it's assets.
		 * @param volume			the desired volume.
		 */
		public function setAllAssetsVolume (timelines:uint, volume:Number):void
		{
			var setVolume:Function = function (asset:AbstractAsset, volume:uint):void
								{
									if (asset.mediaType == MediaTypes.VIDEO || asset.mediaType == MediaTypes.AUDIO)
									{
										asset.audioGraph.setOverallVolume(volume);
									}
								}
			var asset:AbstractAsset;
			var i:int;
			if (timelines & TimelineTypes.VIDEO)
			{
				for (i = 0; i < _videoAssets.length; ++i)
				{
					asset = _videoAssets.getItemAt(i) as AbstractAsset;
					setVolume (asset, volume);
				}
			}
			if (timelines & TimelineTypes.AUDIO)
			{
				for (i = 0; i < _audioAssets.length; ++i)
				{
					asset = _audioAssets.getItemAt(i) as AbstractAsset;
					setVolume (asset, volume);
				}
			}
			buildRoughcutAssets ();
		}

		//private

		//TODO: Implement the following (*Copy from old project to different methods/classes):
		/*
			duplicate asset
			split asset
		*/
	}
}