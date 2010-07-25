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
package com.kaltura.roughcut
{
	import com.kaltura.application.KalturaApplication;
	import com.kaltura.assets.AssetsFactory;
	import com.kaltura.assets.abstracts.AbstractAsset;
	import com.kaltura.base.types.MediaTypes;
	import com.kaltura.base.types.TimelineTypes;
	import com.kaltura.base.vo.KalturaPluginInfo;
	//xxx import com.kaltura.base.vo.KalturaUser;
	import com.kaltura.dataStructures.HashMap;
	import com.kaltura.managers.downloadManagers.DownloadManager;
	import com.kaltura.managers.downloadManagers.protocols.NetProtocolProgressiveDUAL;
	import com.kaltura.plugin.types.transitions.TransitionTypes;
	import com.kaltura.roughcut.assets.RoughcutTimelinesAssets;
	import com.kaltura.roughcut.buffering.BufferMonitor;
	import com.kaltura.roughcut.buffering.events.BufferEvent;
	import com.kaltura.roughcut.events.RoughcutChangeEvent;
	import com.kaltura.roughcut.events.RoughcutStatusEvent;
	import com.kaltura.roughcut.interfaces.IRoughcut;
	//xxx import com.kaltura.roughcut.mediaclips.filter.IFilterOption;
	import com.kaltura.roughcut.mediaclips.settings.MediaTypesSettings;
	//xxx import com.kaltura.roughcut.mediaclips.sort.ISortOption;
	import com.kaltura.roughcut.sdl.RoughcutSDL;
	import com.kaltura.roughcut.soundtrack.AudioPlayPolicy;
	import com.kaltura.types.KalturaEntryStatus;
	import com.kaltura.vo.KalturaMixEntry;
	import com.kaltura.vo.KalturaPlayableEntry;

	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import mx.collections.ArrayCollection;
	//xxx import mx.collections.Sort;
	//xxx import mx.events.CollectionEvent;
	//xxx import mx.events.CollectionEventKind;
	//xxx import mx.events.PropertyChangeEvent;
	import mx.utils.UIDUtil;

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
	* Dispatched after the roughcut duration was changed.
	* @eventType com.kaltura.roughcut.events.RoughcutChangeEvent.ROUGHCUT_DURATION_CHANGE
	*/
	[Event(name="roughcutDurationChange", type="com.kaltura.roughcut.events.RoughcutChangeEvent")]
	/**
	* Dispatched after the changes occured on the roughcut's audio timeline (or soundtrack asset).
	* @eventType com.kaltura.roughcut.buffering.events.BufferEvent.ROUGHCUT_SOUNDTRACK_CHANGE
	*/
	[Event(name="roughcutSoundtrackChange", type="com.kaltura.roughcut.events.RoughcutChangeEvent")]
	/**
	* Dispatched after the first frame of the roughcut was downloaded and is ready to show on screen.
	* after catching this event, it is possible to use <code>Eplayer.seekSequence (0, false, true)</code>
	* to show the first frame on the screen.
	* @eventType com.kaltura.roughcut.events.RoughcutChangeEvent.FIRST_FRAME_LOADED
	*/
	[Event(name="firstFrameLoaded", type="com.kaltura.roughcut.events.RoughcutStatusEvent")]

	/**
	 * the roughcut object is the remixing object, it is used to manage the assets (audio, video, images, plugins...),
	 * "create the mix" and generate the sdl representation of the Kaltura roughcut.
	 */
	public class Roughcut extends KalturaMixEntry implements IRoughcut
	{
		/**
		 * settings of the behaviours of different media types,
		 * ie, setting default color of a solid clip or default transition id when adding new assets.
		 * @see com.kaltura.roughcut.mediaclips.settings.Roughcut.mediaTypesSettings
		 */
		public static var mediaTypesSettings:MediaTypesSettings = new MediaTypesSettings ();

		/**
		 *the roughcut's editor user info.
		 */
		//xxx public var roughcutEditor:KalturaUser;
		/**
		 * the roughtcut's versions (holds RoughcutVersion objects)
		 */
		public var roughcutVersions:ArrayCollection;
		/**
		 *the buffer monitior of this roughcut, use to get aggregated information on the roughcut loading status.
		 */
		public var bufferMonitor:BufferMonitor;
		/**
		 *the used streaming mode to download the media sources.
		 * @see com.kaltura.managers.downloadManagers.types.StreamingModes
		 */
		public var streamingMode:int = 0;
		/**
		*a hashmap contains the assets that are available for this show.
		*/
		protected var _associatedAssets:HashMap = new HashMap ();
		/**
		*the allowed media types to show on the mediaClips array collection.
		*/
		protected var _mediaClipsAllowedTypes:uint = 0xffffffff;
		/**
		* the roughcut SDL.
		*/
		/* [Bindable] */ public var roughcutSDL:RoughcutSDL;
		/**
		* the roughcut timelines.
		*/
		/* [Bindable] */ public var roughcutTimelines:RoughcutTimelinesAssets;
		/**
		* the asset that represents the soundtrack if we use setSoundtrackAsset function.
		*/
		//xxx [Bindable(event="roughcutSoundtrackChange")]
		public var soundtrackAsset:AbstractAsset;
		/**
		*the mediaClips asset that represents the selected soundtrackAsset in the mediaClips.
		*/
		//xxx [Bindable(event="roughcutSoundtrackChange")]
		public function get selectedSoundtrackEntry ():AbstractAsset
		{
			if (soundtrackAsset)
				return _associatedAssets.getValue (soundtrackAsset.entryId) as AbstractAsset;
			else
				return KalturaApplication.nullAsset;
		}
		/**
		* whether this roughcut's soundtrack asset should play once or repeat untill video timeline finish.
		* @see com.kaltura.roughcut.soundtrack.AudioPlayPolicy#AUDIO_PLAY_POLICY_REPEAT
		* @see com.kaltura.roughcut.soundtrack.AudioPlayPolicy#AUDIO_PLAY_POLICY_ONCE
		* @see com.kaltura.roughcut.soundtrack.AudioPlayPolicy#AUDIO_PLAY_POLICY_ALL
		*/
		//xxx [Bindable(event="roughcutSoundtrackChange")]
		public function set soundtrackAudioPolicy (audio_policy:uint):void
		{
			dirty = true;
			if (roughcutTimelines)
				roughcutTimelines.soundtrackFirstAssetPolicy = audio_policy;
			dispatchEvent(new RoughcutChangeEvent (RoughcutChangeEvent.ROUGHCUT_SOUNDTRACK_CHANGE));
		}
		public function get soundtrackAudioPolicy ():uint
		{
			if (roughcutTimelines)
				return roughcutTimelines.soundtrackFirstAssetPolicy;
			else
				return 0;
		}
		/**
		* describe whether the soundtrack should play silently, mute or continue as is when crossing video assets.
		* @see com.kaltura.roughcut.soundtrack.AudioPlayPolicy#CROSS_VIDEO_SILENT
		* @see com.kaltura.roughcut.soundtrack.AudioPlayPolicy#CROSS_VIDEO_MUTE
		* @see com.kaltura.roughcut.soundtrack.AudioPlayPolicy#CROSS_VIDEO_NO_ACTION
		*/
		//xxx [Bindable(event="roughcutSoundtrackChange")]
		public function set soundtrackVolumePlayPolicy (volume_policy:uint):void
		{
			if (roughcutTimelines)
				roughcutTimelines.soundtrackVolumePlayPolicy = volume_policy;
			dispatchEvent(new RoughcutChangeEvent (RoughcutChangeEvent.ROUGHCUT_SOUNDTRACK_CHANGE));
		}
		public function get soundtrackVolumePlayPolicy ():uint
		{
			if (roughcutTimelines)
				return roughcutTimelines.soundtrackVolumePlayPolicy;
			else
				return 0;
		}
		//xxx [Bindable(event="roughcutSoundtrackChange")]
		public function set soundtrackVolume (volume:Number):void
		{
			if (roughcutTimelines)
				roughcutTimelines.soundtrackVolume = volume;
			dispatchEvent(new RoughcutChangeEvent (RoughcutChangeEvent.ROUGHCUT_SOUNDTRACK_CHANGE));
		}
		public function get soundtrackVolume ():Number
		{
			if (roughcutTimelines)
				return roughcutTimelines.soundtrackVolume;
			else
				return 0;
		}
		//xxx [Bindable(event="roughcutSoundtrackChange")]
		public function set soundtrackSilentVolume (volume:Number):void
		{
			if (roughcutTimelines)
				roughcutTimelines.soundtrackSilentVolume = volume;
			dispatchEvent(new RoughcutChangeEvent (RoughcutChangeEvent.ROUGHCUT_SOUNDTRACK_CHANGE));
		}
		public function get soundtrackSilentVolume ():Number
		{
			if (roughcutTimelines)
				return roughcutTimelines.soundtrackSilentVolume;
			else
				return 0;
		}
		/**
		* duration of this roughcut
		*/
		//xxx [Bindable(event="roughcutDurationChange")]
		public var roughcutDuration:Number = 0;
		/**
		 * keeps track of roughcut changes, if roughcut is empty, buildTimeline should be preformed before playing.
		 */
		public var dirty:Boolean = true;
		/**
		 * the default duration in seconds for adding new static assets (does not apply for audio or video assets).
		 */
		public var defaultNewAssetDuration:Number = 5;
		/**
		 * checks if the roughcut was modified during this session.
		 * this function compares the original loaded sdl to the current sdl and return the result.
		 * <p>NOTE: this can only be used AFTER the roughcut dispatched <code>BufferEvent.PLUGINS_DOWNLOAD_COMPLETE<code>,
		 * if method is needed, make sure to wait till after the event.</p>
		 * @return 		whether the roughcut was changed during this session.
		 */
		public function get isModified ():Boolean
		{
			var wasModified:Boolean = !(roughcutSDL.originalSDL == roughcutSDL.currentSDL);
			return wasModified;
		}
		/**
		* determine if the roughcut has entries in the timeline or it's empty.
		*/
		//xxx [Inspectable]
		//xxx [Bindable (event="roughcutDurationChange")]
		public function get hasEntriesInTimeline ():Boolean
		{
			if (roughcutTimelines && roughcutTimelines.videoAssets && roughcutTimelines.audioAssets)
				return roughcutTimelines.videoAssets.length > 0 || roughcutTimelines.audioAssets.length > 0;
			else
				return false;
		}
		/**
		 * in case an admin, deleted entries from the system, we mark these entries as deleted.
		 * contains DeletedEntry instances.
		 * @see com.kaltura.base.vo.DeletedEntry
		 */
		public function get deletedEntries ():ArrayCollection
		{
			return roughcutSDL.deletedEntries;
		}

		/**
		 *Constructor.
		 * @param mixEntry		the entry of this roughcut.
		 */
		public function Roughcut (mixEntry:KalturaMixEntry):void
		{
			super ();
			copyEntryProperties (mixEntry);
			_solidAsset = createSolidAsset();
			_silenceAsset = createSilenceAsset();
			_originalMediaClips.addItem(_silenceAsset);
			_originalMediaClips.addItem(_solidAsset);
		}

		private function copyEntryProperties (mixEntry:KalturaMixEntry):void
		{
			for (var i:String in mixEntry)
			{
				if (this.hasOwnProperty(i))
					this[i] = mixEntry[i];
			}
		}

		//=====================================================================================================================================
		//SDL Operations:
		/**
		 *save the sdl and excute build the roughcut timelines.
		 * @param sdl				the sdl to parse.
		 * @param validate_sdl		true if the sdl should be validate with the getallentries servcie.
		 */
		public function parseSDL (sdl:XML, validate_sdl:Boolean = true):void
		{
			roughcutSDL = new RoughcutSDL (id, version, sdl);
			roughcutTimelines = roughcutSDL.parseAndBuildTimelines (_associatedAssets, validate_sdl);
			soundtrackAsset = roughcutTimelines.soundtrackAsset;
			soundtrackAudioPolicy = roughcutTimelines.soundtrackFirstAssetPolicy;
			soundtrackVolume = roughcutTimelines.soundtrackVolume;
			soundtrackSilentVolume = roughcutTimelines.soundtrackSilentVolume;
			roughcutTimelines.addEventListener(RoughcutChangeEvent.ROUGHCUT_DURATION_CHANGE, roughcutDurationChanged, false, 0, true);
			roughcutTimelines.addEventListener(RoughcutChangeEvent.ROUGHCUT_SOUNDTRACK_CHANGE, roughcutSoundtrackChange, false, 0, true);
			roughcutTimelines.addEventListener(RoughcutChangeEvent.ROUGHCUT_DIRTY, setRoughcutDirty, false, 0, true);
			roughcutTimelines.addEventListener(RoughcutStatusEvent.FIRST_FRAME_LOADED, dispatchFirstFrameLoaded, false, 0, true);
			roughcutTimelines.buildRoughcutAssets();
			dirty = false;
		}

		/**
		 *when the first asset has enough data to show the first frame of the roughcut, dispatch a firstFrameLoaded status event.
		 * <p>when loading a roughcut to the player, use this event to determine when the player is ready for the first seek.</p>
		 */
		protected function dispatchFirstFrameLoaded (event:RoughcutStatusEvent):void
		{
			if (bufferMonitor)
				dispatchEvent(event.clone());
		}

		/**
		 * mark the roughcut as dirty and needs to be rebuild.
		 */
		protected function setRoughcutDirty (event:RoughcutChangeEvent):void
		{
			dirty = true;
		}

		/**
		 *Event handler for roughcut's soundtrack change.
		 * @see com.kaltura.roughcut.assets.RoughcutTimelinesAssets
		 * @see com.kaltura.roughcut.events.RoughcutChangeEvent
		 */
		private function roughcutSoundtrackChange (e:RoughcutChangeEvent):void
		{
			soundtrackAsset = roughcutTimelines.soundtrackAsset;
			soundtrackAudioPolicy = roughcutTimelines.soundtrackFirstAssetPolicy;
			dispatchEvent(e.clone());
		}

		/**
		 *Event hadnler for roughcut's duration change.
		 * @see com.kaltura.roughcut.assets.RoughcutTimelinesAssets
		 * @see com.kaltura.roughcut.events.RoughcutChangeEvent
		 */
		private function roughcutDurationChanged (e:RoughcutChangeEvent):void
		{
			roughcutDuration = roughcutTimelines.roughcutDuration;
			dispatchEvent(e.clone());
		}

		/**
		 *build SDL from a given roughcut timelines, saves it as the current SDL and return it.
		 * <p>before running this you must call preSequencePlay on a the player.</p>
		 * @param roughcutTimelines		the roughcut timelines to build.
		 * @return 						the new SDL.
		 * @see Sequence Description Language.
		 */
		public function buildSDL ():XML
		{
			roughcutTimelines.buildRoughcutAssets();
			if (editorType)
				return roughcutSDL.buildSDL(roughcutTimelines, editorType);
			else
				return roughcutSDL.buildSDL(roughcutTimelines);
		}

		//=====================================================================================================================================
		//Roughcut operations:
		/**
		 * builds the roughcut assets array, the roughcutAssets is used in the players.
		 * <p>this function should be run before exporting sdl in order </p>
		 */
		public function buildRoughcutAssets ():void
		{
			if (roughcutTimelines)
			{
				roughcutTimelines.buildRoughcutAssets();
			} else {
				trace ("\n=======================================\n" +
						"Warning: we've been asked to build a roughcut that doesn't have an sdl yet.\n" +
						"=======================================\n");
			}
		}
		/**
		 *the media clips for this roughcut, as a hashmap.
		 */
		public function get associatedAssets ():HashMap
		{
			return _associatedAssets;
		}
		public function set associatedAssets (assetsMap:HashMap):void
		{
			_associatedAssets = assetsMap;
		}

		protected var _mediaClips:ArrayCollection = new ArrayCollection ();
		/**
		 *the media clips for this roughcut, as arrayCollection.
		 */
		//xxx [Bindable]
		public function get mediaClips ():ArrayCollection
		{
			return _mediaClips;
		}
		public function set mediaClips (clipsAC:ArrayCollection):void
		{
			_mediaClips = clipsAC;
		}

		protected var _originalMediaClips:ArrayCollection = new ArrayCollection ();		//for filtering purposes
		/**
		*array collection with the same assets, to be exposed for outside.
		*/
		public function get originalAssets ():ArrayCollection
		{
			return _originalMediaClips;
		}
		public function set originalAssets (clipsAC:ArrayCollection):void
		{
			_originalMediaClips = clipsAC;
		}

		protected var _mediaClipsImages:ArrayCollection = new ArrayCollection ();
		/**
		 *the media clips for this roughcut, only the image type items.
		 */
		//xxx [Bindable]
		public function get mediaClipsImages ():ArrayCollection
		{
			return _mediaClipsImages;
		}
		public function set mediaClipsImages (clipsAC:ArrayCollection):void
		{
			_mediaClipsImages = clipsAC;
		}
		protected var _mediaClipsAudio:ArrayCollection = new ArrayCollection ();
		/**
		 *the media clips for this roughcut, only the audio type items.
		 */
		//xxx [Bindable]
		public function get mediaClipsAudio ():ArrayCollection
		{
			return _mediaClipsAudio;
		}
		public function set mediaClipsAudio (clipsAC:ArrayCollection):void
		{
			_mediaClipsAudio = clipsAC;
		}
		protected var _mediaClipsVideo:ArrayCollection = new ArrayCollection ();
		/**
		 *the media clips for this roughcut, only the video type items.
		 */
		//xxx [Bindable]
		public function get mediaClipsVideo ():ArrayCollection
		{
			return _mediaClipsVideo;
		}
		public function set mediaClipsVideo (clipsAC:ArrayCollection):void
		{
			_mediaClipsVideo = clipsAC;
		}
		protected var _mediaClipsVisual:ArrayCollection = new ArrayCollection ();
		/**
		 *the media clips for this roughcut, only the video and images type items.
		 */
		//xxx [Bindable]
		public function get mediaClipsVisual ():ArrayCollection
		{
			return _mediaClipsVisual;
		}
		public function set mediaClipsVisual (clipsAC:ArrayCollection):void
		{
			_mediaClipsVisual = clipsAC;
		}

		/**
		 * sets the mediaClips arrayCollection.
		 * @param clipsArray
		 */
		public function setMediaClipsSource (clipsArray:Array):void
		{
			_mediaClips.source = clipsArray;
			_originalMediaClips.source = clipsArray;
			associatedAssets.clear();
			for (var i:int = _mediaClips.length; i >= 0; --i)
				associatedAssets.put (_mediaClips.getItemAt(i).id, _mediaClips.getItemAt(i));
			//xxx mediaClipsChange (null);
		}

		/**
		 * track changes in the mediaclips and distribute it to the different mediaclips arrays.
		 */
/*xxx
 		private function mediaClipsChange (event:CollectionEvent):void
		{
			if (!mediaClips || !_originalMediaClips)
				return;

			if (event == null || event.kind == CollectionEventKind.ADD ||
								event.kind == CollectionEventKind.MOVE ||
								event.kind == CollectionEventKind.REMOVE ||
								event.kind == CollectionEventKind.REPLACE ||
								event.kind == CollectionEventKind.RESET )
			{
				_originalMediaClips.addEventListener(CollectionEvent.COLLECTION_CHANGE, mediaClipsChange, false, 0, true);

				var mediaTypes:uint;
				if (Roughcut.mediaTypesSettings && Roughcut.mediaTypesSettings.showSilenceInMediaClips)
					mediaTypes = MediaTypes.SILENCE;
				if (Roughcut.mediaTypesSettings && Roughcut.mediaTypesSettings.showSolidInMediaClips)
					mediaTypes = mediaTypes | MediaTypes.SOLID;
				mediaTypes = mediaTypes | MediaTypes.AUDIO | MediaTypes.VIDEO | MediaTypes.IMAGE;

				var filterFunction:Function = mediaClips.filterFunction;
				var sort:Sort = mediaClips.sort;
				mediaClips = getMediaClipsByTypes (mediaTypes);
				if (Roughcut.mediaTypesSettings && Roughcut.mediaTypesSettings.showSilenceInMediaClips)
					 mediaTypes = MediaTypes.AUDIO | MediaTypes.SILENCE;
				else
					mediaTypes = MediaTypes.AUDIO;
				mediaClips.filterFunction = filterFunction;
				mediaClips.sort = sort;
				mediaClips.refresh();

				filterFunction = mediaClipsAudio.filterFunction;
				sort = mediaClipsAudio.sort;
				mediaClipsAudio = getMediaClipsByTypes(mediaTypes);
				mediaClipsAudio.filterFunction = filterFunction;
				mediaClipsAudio.sort = sort;
				mediaClipsAudio.refresh();

				filterFunction = mediaClipsImages.filterFunction;
				sort = mediaClipsImages.sort;
				mediaClipsImages = getMediaClipsByTypes(MediaTypes.IMAGE);
				mediaClipsImages.filterFunction = filterFunction;
				mediaClipsImages.sort = sort;
				mediaClipsImages.refresh();

				filterFunction = mediaClipsVideo.filterFunction;
				sort = mediaClipsVideo.sort;
				mediaClipsVideo = getMediaClipsByTypes(MediaTypes.VIDEO);
				mediaClipsVideo.filterFunction = filterFunction;
				mediaClipsVideo.sort = sort;
				mediaClipsVideo.refresh();

				if (Roughcut.mediaTypesSettings && Roughcut.mediaTypesSettings.showSolidInMediaClips)
					 mediaTypes = MediaTypes.VIDEO | MediaTypes.IMAGE | MediaTypes.SOLID;
				else
					mediaTypes = MediaTypes.VIDEO | MediaTypes.IMAGE;

				filterFunction = mediaClipsVisual.filterFunction;
				sort = mediaClipsVisual.sort;
				mediaClipsVisual = getMediaClipsByTypes(mediaTypes);
				mediaClipsVisual.filterFunction = filterFunction;
				mediaClipsVisual.sort = sort;
				mediaClipsVisual.refresh();
			}
		}
		public function mediaClipsUpdate ():void
		{
			mediaClipsChange (null);
		}
 */
		/**
		 *@private
		 * handles entry status changes.
		 */
/* 	xxx	public function entryStatusChange (event:PropertyChangeEvent):void
		{
			if (event.property != "status")
				return;
			var entry:KalturaPlayableEntry = event.currentTarget as KalturaPlayableEntry;
			if (entry.status == KalturaEntryStatus.BLOCKED || entry.status == KalturaEntryStatus.DELETED || entry.status == KalturaEntryStatus.ERROR_CONVERTING)
			{
				removeEntryFromArrayById (_mediaClips, entry.id);
				removeEntryFromArrayById (_originalMediaClips, entry.id);
			}
		}
 */
		private function removeEntryFromArrayById (arr:ArrayCollection, entry_id:String):void
		{
			var n:int = arr.length;
			var asset:AbstractAsset;
			var removeIdx:int = -1;
			for (var i:int = 0; i < n; ++i)
			{
				asset = arr.getItemAt(i) as AbstractAsset;
				if (asset.entryId == entry_id)
				{
					removeIdx = i;
					break;
				}
			}
			if (removeIdx > -1)
			{
				arr.removeItemAt(removeIdx);
			}
		}

		/**
		 * filters the mediaClips to show only selected media types.
		 * @param types		the types of media assets to be shown (all other will be filtered out).
		 * @see	com.kaltura.common.types.MediaTypes
		 */
		public function filterMediaClipsByMediaType (types:uint):void
		{
			_mediaClipsAllowedTypes = types;
			//xxx _mediaClips.filterFunction = filterMediaClips;
			//xxx _mediaClips.refresh();
		}

		/**
		 *sets a custom filter function for the mediaClips.
		 * @param filterFunction		a function to filter the assets according to.
		 * @see mx.collections.ICollectionView#filterFunction
		 */
		public function filterMediaClipsCustom (filterFunction:Function):void
		{
			_mediaClipsAllowedTypes = MediaTypes.ANY_TYPE;
			//xxx _mediaClips.filterFunction = filterFunction;
			//xxx _mediaClips.refresh();
		}

		/**
		 * adds a special asset of media type silence.
		 * silence assets are assets the represents a place holder for quite sections between audio assets.
		 * this asset is only generated at run-time and saved on the roughcut, there's no server media type correspondant.
		 * @param arrayCollection			the mediaclips to add this item to, if null will be added to mediaClips.
		 */
		public function mediaclipsAddSilenceType (arrayCollection:ArrayCollection = null):void
		{
			if (arrayCollection)
				arrayCollection.addItemAt(_silenceAsset, 0);
			else
				mediaClips.addItemAt(_silenceAsset, 0);
		}
		private function createSilenceAsset ():AbstractAsset
		{
			if (_silenceAsset)
				return _silenceAsset;
			_silenceAsset = AssetsFactory.create(MediaTypes.SILENCE, UIDUtil.createUID(),
					"silence-" + MediaTypes.SILENCE.toString(), MediaTypes.getLocaleMediaType(MediaTypes.SILENCE),
					"", "", Roughcut.mediaTypesSettings.defaultSilenceDuration, Roughcut.mediaTypesSettings.defaultMaxStaticTypesDuration);
			_associatedAssets.put(_silenceAsset.entryId, _silenceAsset);
			return _silenceAsset;
		}

		/**
		 * adds a special asset of media type solid.
		 * solid color assets are assets the represents a slide of certain color.
		 * this asset is only generated at run-time and saved on the roughcut, there's no server media type correspondant.
		 * @param arrayCollection			the mediaclips to add this item to, if null will be added to mediaClips.
		 */
		public function mediaclipsAddSolidType (arrayCollection:ArrayCollection = null):void
		{
			mediaClips.addItemAt(_solidAsset, 0);
		}
		private function createSolidAsset ():AbstractAsset
		{
			if (_solidAsset)
				return _solidAsset;
			var bd:BitmapData = new BitmapData (KalturaApplication.getInstance().initPlayerWidth,
								KalturaApplication.getInstance().initPlayerHeight, false, Roughcut.mediaTypesSettings.defaultSolidColor);
			var bmp:Bitmap = new Bitmap (bd);
			var colorName:String = ""; //xxx ColorsUtil.getName(Roughcut.mediaTypesSettings.defaultSolidColor)[1];	//get the name of that color
			var solidAsset:AbstractAsset;
			var transitiondur:Number = Roughcut.mediaTypesSettings.defaultTransitionDuration;
			transitiondur = transitiondur > Roughcut.mediaTypesSettings.defaultSolidDuration ?
							Roughcut.mediaTypesSettings.defaultSolidDuration < 2.5 ?
							Roughcut.mediaTypesSettings.defaultSolidDuration * 0.3 : 2 : transitiondur;
			solidAsset = AssetsFactory.create (MediaTypes.SOLID, 'null', "solid-" + MediaTypes.SOLID.toString(),
											MediaTypes.getLocaleMediaType(MediaTypes.SOLID),
											Roughcut.mediaTypesSettings.defaultSolidColor.toString(), "",
											Roughcut.mediaTypesSettings.defaultSolidDuration,
											Roughcut.mediaTypesSettings.defaultMaxStaticTypesDuration,
											0, 0, Roughcut.mediaTypesSettings.defaultTransitionId,
											transitiondur, false, false, bd);
			solidAsset.thumbBitmap = bmp;
			_solidAsset = solidAsset;
			_associatedAssets.put(_solidAsset.entryId, _solidAsset);
			return solidAsset;
		}

		/**
		 *updates the solid color with the values set to Roughcut>mediaTypesSettings.
		 *@see com.kaltura.roughcut.Roughcut#mediaTypesSettings
		 */
		public function updateSolidColor ():void
		{
			if (!_solidAsset)
				_solidAsset = createSolidAsset();
			var bd:BitmapData = new BitmapData (KalturaApplication.getInstance().initPlayerWidth,
								KalturaApplication.getInstance().initPlayerHeight, false, Roughcut.mediaTypesSettings.defaultSolidColor);
			var bmp:Bitmap = new Bitmap (bd);
			_solidAsset.thumbnailURL = Roughcut.mediaTypesSettings.defaultSolidColor.toString();
			_solidAsset.thumbBitmap = bmp;
			_solidAsset.length = Roughcut.mediaTypesSettings.defaultSolidDuration;
		}

		private var _solidAsset:AbstractAsset;
		/**
		 *explicit getter for mediaclip's solid asset.
		 * @return 		the solid asset in the media clips.
		 */
		public function getSolidAsset ():AbstractAsset
		{
			return createSolidAsset();
		}

		private var _silenceAsset:AbstractAsset;
		/**
		 *explicit getter for mediaclip's silence asset.
		 * @return 		the silence asset in the media clips.
		 */
		public function getSilenceAsset ():AbstractAsset
		{
			return createSilenceAsset();
		}

		/**
		 *builds a new mediaClips arrayCollection that is filtered to hold only given media_types.
		 * @param media_types		the media types to filter in.
		 * @param addNullAsset		if true first item of the returned arrayCollection will be an empty AbstractAsset with entryId = -1000
		 * @param nullAssetName 	the name of the null Asset to add.
		 * @return 					new collection filtered.
		 * @see com.kaltura.roughcut.assets.TimelineTypes
		 */
		public function getMediaClipsByTypes (media_types:uint, addNullAsset:Boolean = false, nullAssetName:String = "nullAsset"):ArrayCollection
		{
			var asset:AbstractAsset;
			var collection:ArrayCollection = new ArrayCollection ();
			var i:int = 0;
			var N:uint = _originalMediaClips.length;
			for (; i< N; ++i)
			{
				asset = _originalMediaClips.getItemAt(i) as AbstractAsset;
				if (asset.mediaType & media_types)
					collection.addItem(asset);
			}
			if (addNullAsset)
			{
				asset = KalturaApplication.nullAsset;
				asset.entryName = nullAssetName;
				collection.addItemAt(asset, 0);
			}
			return collection;
		}

		/**
		 *filters the mediaClips to show only the allowed media types for the given timeline type.
		 * @param timelines		the timelines to filter to.
		 * @see com.kaltura.roughcut.assets.TimelineTypes
		 */
		public function filterMediaClipsByTimeline (timelines:uint):void
		{
			_mediaClipsAllowedTypes = 0;
			if (timelines == TimelineTypes.ANY_TIMELINE)
			{
				_mediaClipsAllowedTypes = timelines;
			} else {
				if (timelines & TimelineTypes.AUDIO)
					_mediaClipsAllowedTypes = MediaTypes.AUDIO;
				if (timelines & TimelineTypes.VIDEO)
					_mediaClipsAllowedTypes = _mediaClipsAllowedTypes | MediaTypes.VIDEO | MediaTypes.SOLID | MediaTypes.IMAGE;
			}
			//xxx _mediaClips.filterFunction = filterMediaClips;
			//xxx _mediaClips.refresh();
		}

		/**
		 *filterFunction for the mediaClips arrayCollectio.
		 * @param asset		the AbstractAsset to be check for filtering.
		 * @return 			true if the asset passed the filter and should be shown on the arrayCollection.
		 * @see mx.collections.ListCollectionView#filterFunction
		 */
		protected function filterMediaClips (asset:AbstractAsset):Boolean
		{
			var result:Boolean = false;
			if (asset.mediaType & _mediaClipsAllowedTypes)
				result = true;
			return result;
		}

		/**
		 *filter a mediaclips array by using a sort option.
		 * @param media_clips		the mediaclips array.
		 * @param sort_option		the sort option to use.
		 * @see com.kaltura.roughcut.mediaclips.sort.ISortOption
		 */
/* xxx		public function sortMediaClipsBy (media_clips:ArrayCollection, sort_option:ISortOption):void
		{
			var sort:Sort = new Sort ();
			sort.compareFunction = sort_option.compareFunction;
			media_clips.sort = sort;
			media_clips.refresh();
		}
 */
		/**
		 *filter a mediaclips array by using a filter option.
		 * @param media_clips		the mediaclips to filter.
		 * @param filter_option		the filter option to use.
		 * @see com.kaltura.roughcut.mediaclips.filter.IFilterOption
		 */
/* xxx		public function filterMediaClipsBy (media_clips:ArrayCollection, filter_option:IFilterOption):void
		{
			media_clips.filterFunction = filter_option.filterFunction;
			media_clips.refresh();
		}
 */
		/**
		 *dispose roughcut from memory.
		 */
		public function dispose():void
		{
			soundtrackAsset = null;
			if (bufferMonitor)
			{
				bufferMonitor.dispose();
				bufferMonitor = null;
			}
			if (roughcutSDL)
			{
				roughcutSDL.dispose();
				roughcutSDL = null;
			}
			if (roughcutTimelines)
			{
				roughcutTimelines.dispose();
				roughcutTimelines = null;
			}
			if (_mediaClips)
			{
				_mediaClips.removeAll();
				_mediaClips = null;
			}
			if (_originalMediaClips)
			{
				_originalMediaClips.removeAll();
				_originalMediaClips = null;
			}
			if (_associatedAssets)
			{
				_associatedAssets.clear();
				_associatedAssets = null;
			}
			if (originalAssets)
			{
				originalAssets.removeAll();
				originalAssets = null;
			}
/*
			roughcutEditor = null;
			if (roughcutVersions)
				roughcutVersions.removeAll();
			roughcutVersions = null;
			roughcutEditor = null;
			NetProtocolProgressiveDUAL.disposeStreamPair(id, version);
*/
		}

		//=====================================================================================================================================
		//Timelines operations:

		/**
		 * preforms a binary search to get the asset on a given timestamp and timeline, if the timeline is empty, this function will return null.
		 * @param target_timeline_type			the timeline on which to search.
		 * @param time_stamp					the timestamp to search.
		 * @return 								the asset on the timeline on thet specific timestamp.
		 */
		public function getAssetAtTime (target_timeline_type:uint, time_stamp:Number):Array
		{
			var asset:AbstractAsset = roughcutTimelines.getAssetAtTime(target_timeline_type, time_stamp);
			var assetIndex:int = roughcutTimelines.getAssetIndex(asset);
			if (asset)
				return [time_stamp <= asset.seqEndPlayTime ? asset : null, assetIndex];
			else
				return [null, null];
		}

		/**
		 *clears all assets from the roughcut's timelines.
		 * @param timelines		the timelines to clear, pass bitmask according to TimelineTypes.
		 * @see com.kaltura.roughcut.assets.TimelineTypes
		 */
		public function clearTimeline (timelines:uint = 0xffffffff):void
		{
			if (timelines == 0xffffffff)
				timelines = TimelineTypes.AUDIO | TimelineTypes.EFFECTS | TimelineTypes.OVERLAYS | TimelineTypes.VIDEO;
			roughcutTimelines.clearTimeline (timelines);
			if (bufferMonitor)
				bufferMonitor.buildBufferArray();
			dirty = true;
		}

		/**
		 *removes a specific asset from the selected timeline.
		 * @param asset_index		the index of the asset in the timeline.
		 * @param timeline			the timeline of the asset.
		 * @param by_asset			to remove an asset by its reference instead of by index.
		 */
		public function removeAsset (asset_index:int, timeline:uint = 0x2, by_asset:AbstractAsset = null):void
		{
			if (by_asset)
			{
				asset_index = roughcutTimelines.videoAssets.getItemIndex(by_asset);
				timeline = TimelineTypes.VIDEO;
				if (asset_index == -1)
				{
					asset_index = roughcutTimelines.audioAssets.getItemIndex(by_asset);
					timeline = TimelineTypes.AUDIO;
				}
				if (asset_index == -1)
				{
					asset_index = roughcutTimelines.overlaysAssets.getItemIndex(by_asset);
					timeline = TimelineTypes.OVERLAYS;
				}
				if (asset_index == -1)
				{
					asset_index = roughcutTimelines.effectsAssets.getItemIndex(by_asset);
					timeline = TimelineTypes.EFFECTS;
				}
			}
			if (asset_index > -1)
			{
				roughcutTimelines.removeAsset (asset_index, timeline);
				if (bufferMonitor)
					bufferMonitor.buildBufferArray();
			}
			dirty = true;
		}

		/**
		 *removes the transition from the asset or group of assets specified.
		 * @param timeline				the timeline the asset is in.
		 * @param clear_all				pass true to clear the transitions from all assets of the timeline.
		 * @param asset_index			the index of the asset to remove it's transition.
		 * @param assets_indices		a list of assets indexs to remove transitions for.
		 */
		public function removeTransitions (timeline:uint = 0x2, clear_all:Boolean = true, asset_index:int = -1, ...assets_indices):void
		{
			roughcutTimelines.removeTransitions (timeline, clear_all, asset_index, assets_indices);
			if (bufferMonitor)
				bufferMonitor.buildBufferArray();
			dirty = true;
		}

		/**
		 *adds a new asset to the roughcut, apply to only kaltura assets (video, audio, images, solids...) and not plugins such as transitions, overlays or effects.
		 * @param entryId				the entry id of the asset to be added.
		 * @param timeline				the timeline to add the assset to.
		 * @param assetIndex			the index in the timeline to add the new asset to, if -1 asset will be added to the end of the timeline.
		 * @param startTime				the cut start time of the new asset (default will be 0).
		 * @param duration				the duration of the new asset (default will be the duration of the asset).
		 * @param transition_type		the plugin id of the transition to add to this new asset.
		 * @param transition_duration	the duration of the transition to add to this new asset (if 0 is provided, no transition will be added).
		 * @param loadAsset				whether or not to load the asset's media source (eg. ExNetStream, Image...) after adding to the timeline.
		 * @return						returns true if entry_id represents an asset that is really associated with this roughcut's media clips.
		 */
		public function addAsset (entry_id:String, timeline:uint, asset_index:int = -1, start_time:Number = 0,
									duration:Number = -1, transition_type:String = "!None", transition_duration:Number = -1,
									transition_cross:Boolean = false, load_asset:Boolean = true):Boolean
		{
			if (transition_type == "None")
				transition_type = TransitionTypes.NONE;
			var sourceAsset:AbstractAsset = _associatedAssets.getValue (entry_id);
			if (sourceAsset)
			{
				// copy this asset
				var newAsset:AbstractAsset = sourceAsset.clone();
				newAsset.startTime = start_time;
				newAsset.length = duration > 0 ? duration :
						(!(newAsset.mediaType == MediaTypes.VIDEO || newAsset.mediaType == MediaTypes.AUDIO) ?
						Roughcut.mediaTypesSettings.defaultImageDuration : newAsset.length);
				if (!(newAsset.mediaType & (MediaTypes.VIDEO | MediaTypes.AUDIO)))
					newAsset.maxLength = Roughcut.mediaTypesSettings.defaultMaxStaticTypesDuration > 0 ?
										 Roughcut.mediaTypesSettings.defaultMaxStaticTypesDuration : Number.MAX_VALUE;
				// add the new asset to the timeline
				var newIndex:int = roughcutTimelines.addAsset (newAsset, asset_index, timeline, load_asset);
				if (transition_type == "!None" && transition_duration == -1)
				{
					transition_type = Roughcut.mediaTypesSettings.defaultTransitionId;
					transition_duration = Roughcut.mediaTypesSettings.defaultTransitionDuration;
					transition_cross = Roughcut.mediaTypesSettings.defaultTransitionCross;
					addAssetTransition (transition_type, transition_duration, newIndex, timeline, transition_cross);
				} else {
					if (transition_type != TransitionTypes.NONE && transition_duration > 0)
						addAssetTransition (transition_type, transition_duration, newIndex, timeline, transition_cross);
				}
				if (bufferMonitor)
					bufferMonitor.buildBufferArray();
				dirty = true;
				return true;
			} else {
				return false;
			}
		}

		/**
		 *duplicates an asset given a source asset to clone.
		 * @param source_asset			the asset to duplicate.
		 * @param timeline				the timeline to duplicate to.
		 * @param asset_index			the index to place the new asset.
		 * @param load_asset			if true will load the new asset's media source.
		 */
		public function duplicateAsset (source_asset:AbstractAsset, timeline:uint, asset_index:int, load_asset:Boolean = true):void
		{
			if (allowedMediaType (timeline, source_asset.mediaType))
			{
				// copy this asset
				var newAsset:AbstractAsset = source_asset.clone();
				// add the new asset to the timeline
				var newIndex:int = roughcutTimelines.addAsset (newAsset, asset_index, timeline, load_asset);
				if (load_asset)
					roughcutTimelines.resetStreamingAsset(newAsset);
				if (bufferMonitor)
					bufferMonitor.buildBufferArray();
				dirty = true;
			}
		}

		/**
		 * checks if a given media type can be added to a given timeline type.
		 * @param timeline			the type of the timeline.
		 * @param media_type		the media type.
		 * @return 					true if the given media type can be added to the given timeline.
		 * @see com.kaltura.common.types.MediaTypes
		 * @see com.kaltura.roughcut.assets.TimelineTypes
		 */
		public function allowedMediaType (timeline:uint, media_type:uint):Boolean
		{
			switch (timeline)
			{
				case TimelineTypes.AUDIO:
					return Boolean (media_type & (MediaTypes.AUDIO | MediaTypes.SILENCE | MediaTypes.VIDEO));
				break;
				case TimelineTypes.VIDEO:
					return Boolean (media_type & (MediaTypes.BITMAP_SOCKET | MediaTypes.IMAGE | MediaTypes.SOLID | MediaTypes.VIDEO));
				break;
				case TimelineTypes.OVERLAYS:
					return Boolean (media_type & (MediaTypes.OVERLAY));
				break;
				case TimelineTypes.EFFECTS:
					return Boolean (media_type & (MediaTypes.EFFECT));
				break;
			}
			return false;
		}

		/**
		 *changes the asset position in the timeline (changes the index in the relavent timeline array).
		 * <p>if the index doesn't exist, nothing will happen.
		 * if the new index is negative, the asset will be set to index 0.
		 * if the new index is larger than the total number of assets in the timeline, the asset will be set to be last.</p>
		 * @param timeline				the relavent timelines (operation can be preformed on multipal timelines).
		 * @param asset_index			the position of the asset in the timeline to change.
		 * @param new_asset_index		the new position (array index) in the timeline.
		 */
		public function moveAsset (timeline:uint, asset_index:uint, new_asset_index:uint):void
		{
			roughcutTimelines.moveAsset (timeline, asset_index, new_asset_index, 1);
			dirty = true;
		}

		/**
		 *adds a transition to specified asset.
		 * @param transition_id			the unique identifier of the transition to add.
		 * @param transition_duration	the length of the transition.
		 * @param asset_index			the index of the asset to which to add the transition.
		 * @param timeline				the timeline of the asset.
		 * @param cross					does this transition perfoms cross between two assets, or just switch between current and next ?
		 */
		public function addAssetTransition (transition_id:String, transition_duration:Number, asset_index:uint, timeline:uint = 0x2, cross:Boolean = false):void
		{
			roughcutTimelines.addAssetTransition (transition_id, transition_duration, asset_index, timeline, cross);
			dirty = true;
		}

		/**
		 *adds a plugin at a given time stamp in the roughcut (plugin can be either an overlay, text overlay or an effect).
		 * @param plugin			the plugin info that describe the plugin to add.
		 * @param time_stamp		the time to add this plugin at.
		 * @param length_sec		the length in seconds for the new plugin.
		 * @param timeline			the timeline this plugin should be added to.
		 * @return 					the index of the new item.
		 */
		public function addPlugin (plugin:KalturaPluginInfo, time_stamp:Number, length_sec:Number = 5, timeline:uint = 0x2):uint
		{
			var idx:uint = roughcutTimelines.addPlugin(plugin, time_stamp, length_sec, timeline);
			dirty = true;
			return idx;
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
			roughcutTimelines.setAssetDuration (timelines, asset_index, duration, assets_indices);
			dirty = true;
		}

		/**
		 *changes volume for specific assets.
		 * @param timelines			the timelines in which the assets are, volume is Number 0 - 1.
		 * @param asset_index		the index of the asset in the timeline.
		 * @param volume			the new volume to set.
		 * @param assets_indices	array of indexs for changing multipal assets.
		 */
		public function setAssetVolume (timelines:uint, asset_index:uint, volume:Number, assets_indices:Array = null):void
		{
			roughcutTimelines.setAssetVolume (timelines, asset_index, volume, assets_indices);
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
			roughcutTimelines.setAssetBalance (timelines, asset_index, balance, assets_indices);
		}

		/**
		 *changes duration for specific asset's transition.
		 * @param timeline			the timeline in which the asset is.
		 * @param asset_index		the index of the asset in the timeline.
		 * @param duration			the new duration to set.
		 */
		public function setTransitionDuration (timeline:uint, asset_index:uint, duration:Number):void
		{
			roughcutTimelines.setTransitionDuration (timeline, asset_index, duration);
			dirty = true;
		}

		/**
		 *change the start time of specific asset.
		 * @param timeline			the timeline in which the asset is.
		 * @param asset_index		the index of the asset in the timeline.
		 * @param start_time		the new start time value.
		 */
		public function setAssetStartTime (timeline:uint, asset_index:uint, start_time:Number):void
		{
			roughcutTimelines.setAssetStartTime(timeline, asset_index, start_time);
			dirty = true;
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
			roughcutTimelines.trimAsset (timeline, asset_index, start_time, duration);
			dirty = true;
		}

		/**
		 *replaces the asset in the given timeline at the given index with a new asset.
		 * @param timeline			the timeline of the asset to be replaced.
		 * @param asset_index		the index on the timeline of the asset to be replaces.
		 * @param entry_id			the entry id of the new asset.
		 * @param loadAsset			whether or not to load the asset's media source (eg. ExNetStream, Image...) after adding to the timeline.
		 * @param completeHandle	a function to be called when asset finish loading.
		 * @return					returns true if entry_id represents an asset that is really associated with this roughcut's media clips.
		 */
		public function replaceAsset (timeline:uint, asset_index:uint, entry_id:String, load_asset:Boolean = true, completeHandle:Function = null):Boolean
		{
			var asset:AbstractAsset;
			if (timeline == TimelineTypes.AUDIO)
				asset = roughcutTimelines.audioAssets.getItemAt(asset_index) as AbstractAsset;
			if (timeline == TimelineTypes.VIDEO)
				asset = roughcutTimelines.videoAssets.getItemAt(asset_index) as AbstractAsset;
			if (timeline == TimelineTypes.EFFECTS)
				asset = roughcutTimelines.effectsAssets.getItemAt(asset_index) as AbstractAsset;
			if (timeline == TimelineTypes.OVERLAYS)
				asset = roughcutTimelines.overlaysAssets.getItemAt(asset_index) as AbstractAsset;
			if (timeline == TimelineTypes.TRANSITIONS)
			{
				var transitionParent:AbstractAsset = roughcutTimelines.videoAssets.getItemAt(asset_index) as AbstractAsset;
				asset = transitionParent.transitionAsset;
			}
			if (!asset)
			{
				throw (new Error ("the given asset_index is not valid or the timeline doesn't exist"));
			}
			var sourceAsset:AbstractAsset = _associatedAssets.getValue (entry_id);
			if (sourceAsset)
			{
				asset.length = (asset.mediaType & MediaTypes.VIDEO || asset.mediaType & MediaTypes.AUDIO) ?
								(asset.length <= (sourceAsset.maxLength - sourceAsset.startTime) ? asset.length :
								(sourceAsset.maxLength - sourceAsset.startTime)) :
								asset.length;
				asset.mediaType = sourceAsset.mediaType;
				asset.mediaURL = sourceAsset.mediaURL;
				asset.thumbBitmap = sourceAsset.thumbBitmap;
				asset.thumbnailURL = sourceAsset.thumbnailURL;
				asset.entryId = sourceAsset.entryId;
				asset.entryContributor = sourceAsset.entryContributor;
				asset.entryName = sourceAsset.entryName;
				if (load_asset)
					DownloadManager.getInstance().loadAsset (id, version, asset, completeHandle);
				roughcutTimelines.buildRoughcutAssets();
				dirty = true;
				return true;
			} else {
				return false;
			}
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
			return roughcutTimelines.getAssetAt(timeline, asset_index, fail_safe);
		}

		/**
		 *splits an asset to two different assets in a given time.
		 * <p>note that the given time should relative to the asset itself, not a roughcut time.</p>
		 * @param target_asset		the asset to split into two.
		 * @param time_to_split		the time to split the asset at, this should be relative to the asset's time.
		 */
		public function spliteAsset (target_asset:AbstractAsset, time_to_split:Number):void
		{
			roughcutTimelines.spliteAsset(target_asset, time_to_split);
		}

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
			if (!roughcutTimelines)
				return;
			roughcutTimelines.loadAssetsMediaSources (types, streamingMode);
			bufferMonitor = new BufferMonitor (this);
			if (roughcutTimelines.doFirstFrame)
				dispatchEvent(new RoughcutStatusEvent (RoughcutStatusEvent.FIRST_FRAME_LOADED));
			bufferMonitor.addEventListener(BufferEvent.PLUGINS_DOWNLOAD_COMPLETE, roughcutPluginsDownloadComplete, false, 0, true);
			bufferMonitor.addEventListener(BufferEvent.DOWNLOAD_COMPLETE, roughcutDownloadComplete, false, 0, true);
			bufferMonitor.monitorDownload = true;
			dirty = true;
		}

		/**
		 * catches the plugins download finish event.
		 * @private
		 */
		protected function roughcutPluginsDownloadComplete (event:BufferEvent):void
		{
			dirty = true;
			roughcutSDL.buildOriginalSdl (roughcutTimelines);
			dispatchEvent(event.clone());
		}

		/**
		 * catches the download finish event.
		 * @private
		 */
		protected function roughcutDownloadComplete (event:BufferEvent):void
		{
			dispatchEvent(event.clone());
		}

		// =================================================================================
		// Soundtrack functions:

		/**
		 *adds a new audio asset to the roughcut's audio timeline.
		 * <p>the entry can be also video media type, we will take only the audio out of it.
		 * using this interface, if the ausio timeline already contains assets, the timeline will be cleared.</p>
		 * @param entryId			the entry id of the audio or video asset to be added, if given entryId = -1000, function will call clearSoundtrack instead.
		 * @param startTime			the cut start time of the new asset (default will be 0).
		 * @param duration			the duration of the new asset (default will be the duration of the asset).
		 * @param loadAsset			whether or not to load the asset's media source (eg. ExNetStream, Image...) after adding to the timeline.
		 * @return					returns true if entry_id represents an asset that is really associated with this roughcut's media clips and is mediaType AUDIO or VIDEO.
		 * @see com.kaltura.common.types.MediaTypes
		 */
		public function setSoundtrackAsset (entry_id:String, start_time:Number = 0, duration:Number = -1, load_asset:Boolean = true):Boolean
		{
			if (entry_id == '-1000')
			{
				clearSoundtrack ();
				return false;
			} else {
				roughcutTimelines.clearTimeline(TimelineTypes.AUDIO);
				var sourceAsset:AbstractAsset = _associatedAssets.getValue (entry_id);
				if (sourceAsset)
				{
					if (!(sourceAsset.mediaType & MediaTypes.VIDEO || sourceAsset.mediaType & MediaTypes.AUDIO))
						return false;
					// copy this asset
					var newAsset:AbstractAsset = sourceAsset.clone();
					newAsset.startTime = start_time;
					newAsset.length = duration > 0 ? duration : newAsset.length;
					newAsset.mediaType = MediaTypes.AUDIO;
					// add the new asset to the timeline
					roughcutTimelines.soundtrackAsset = newAsset;
					if (soundtrackAudioPolicy == AudioPlayPolicy.AUDIO_PLAY_POLICY_ALL)
					{
						roughcutTimelines.soundtrackFirstAssetPolicy = AudioPlayPolicy.AUDIO_PLAY_POLICY_REPEAT;
						soundtrackAudioPolicy = AudioPlayPolicy.AUDIO_PLAY_POLICY_REPEAT;
					}
					roughcutTimelines.addAsset (newAsset, 0, TimelineTypes.AUDIO, load_asset);
					soundtrackAsset = newAsset;
					roughcutTimelines.soundtrackAsset = newAsset;
					dispatchEvent(new RoughcutChangeEvent (RoughcutChangeEvent.ROUGHCUT_SOUNDTRACK_CHANGE));
					if (bufferMonitor)
						bufferMonitor.buildBufferArray();
					dirty = true;
					return true;
				} else {
					return false;
				}
			}
		}

		/**
		 * clear the audio timeline and the soundtrack asset, if we use setSoundtrackAsset function, we need to use this function to clear the soundtrack.
		 * @see com.kaltura.roughcut.Roughcut#setSoundtrackAsset
		 */
		public function clearSoundtrack ():void
		{
			soundtrackAsset = null;
			roughcutTimelines.soundtrackAsset = null;
			roughcutTimelines.clearTimeline (TimelineTypes.AUDIO);
			if (bufferMonitor)
				bufferMonitor.buildBufferArray();
			dirty = true;
		}

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
			roughcutTimelines.setAllAssetsDuration(timelines, media_types, duration);
			dirty = true;
		}

		/**
		 *sets a desired transition type on all assets of video timeline.
		 * @param media_types			the media types of the assets to set transition to (ie, set only images).
		 * @param transition_type		the type of the transition to set.
		 * @param transition_duration	the duration of the transition.
		 * @see com.kaltura.plugin.types.transitions.TransitionTypes
		 */
		public function setAllAssetsTransition (media_types:uint, transition_type:String, transition_duration:Number):void
		{
			roughcutTimelines.setAllAssetsTransition(media_types, transition_type, transition_duration);
			dirty = true;
		}

		/**
		 *sets a desired volume to all assets of the timeline.
		 * @param timelines			the timelines to sets volume to it's assets, volume is Number 0 - 1.
		 * @param volume			the desired volume.
		 */
		public function setAllAssetsVolume (timelines:uint, volume:Number):void
		{
			roughcutTimelines.setAllAssetsVolume(timelines, volume);
		}
	}
}