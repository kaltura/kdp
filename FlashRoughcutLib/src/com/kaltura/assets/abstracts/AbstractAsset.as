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
package com.kaltura.assets.abstracts
{
	import com.kaltura.assets.AssetsFactory;
	import com.kaltura.assets.dataStructures.audio.AudioGraph;
	import com.kaltura.assets.interfaces.IAssetable;
	import com.kaltura.base.IDisposable;
	import com.kaltura.base.types.MediaTypes;
	import com.kaltura.net.loaders.interfaces.IMediaSourceLoader;
	import com.kaltura.plugin.logic.Plugin;
	import com.kaltura.types.KalturaEntryStatus;
	import com.kaltura.vo.KalturaPlayableEntry;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.system.LoaderContext;
	
	//xxx import mx.controls.Image;
	//xxx import mx.events.PropertyChangeEvent;

	//[Bindable]
	public class AbstractAsset extends EventDispatcher implements IAssetable, IDisposable
	{
		static public const DEFAULT_TRANSITION_TYPE:String = 'None';
		static public var noneTransitionThumbnail:String = 'http://kaldev.kaltura.com/swf/plugins/cvesdk/transitions/no_transition_thumb.swf';
		protected var _assetUid:String = '-1'; 									//run time generated unique id
		protected var _mediaSource:* = null; 									//Media object, can be any type of media. (NetStream, bitmapData, Sound...)
		protected var _mediaSourceLoader:IMediaSourceLoader;					//the MediaSource loader object, this is used to get info about loading status of media Source.
		protected var _entryId:String = '-1'; 									//id from server (entry id)
		protected var _entryName:String = ""; 									//user specified name (not unique)
		protected var _thumbnailURL:String = ""; 								//thumbnail's URL
		protected var _mediaType:int; 											//media type constants (VIDEO, IMAGE, SOUND, VOICE...)
		protected var _mediaURL:String = ""; 									//the source url of the asset (deprecated, we're now using the entry id to load assets)
		protected var _length:Number = -1; 										//video playing time. can be less than the flv duration if the user chooses to play only part opf the flv
		protected var _maxLength:Number = -1; 									//max video playing time (in video and sound, the duration of the original file)
		protected var _startTime:Number = -1; 									//the start time in seconds to start play inside the clip
		protected var _audioBalance:Number = 0;									//the balance (LEFT -1 - CENTER 0 - RIGHT 1)
		protected var _focus:Boolean = false;									//is this asset is now the active selection (has application focus) ?
		protected var _selected:Boolean = false;								//asset can be selected as part of collection.
		protected var _seqStartPlayTime:Number = 0; 							//the start point of the media at the main timeline (sequence)
		protected var _seqEndPlayTime:Number = 0; 								// the end poing of the media at the main timeline in sec..
		protected var _seqTransitionPlayTime:Number = 0;						//the start point of the transition in seconds
		protected var _transitionLength:Number = 0; 							//Transition duration in seconds.
		protected var _orderBy:Number = 0; 										//This asset's index in the main timeline (sequence), receives its value from the preSequencePlay() function
		protected var _originalIndex:uint = 0; 									//the asset index in the original editor array
		protected var _entryContributor:String = '';							//the name of the user who contributed this asset
		protected var _transitionType:String = DEFAULT_TRANSITION_TYPE;			//type of transition applied to this asset
		protected var _transitionLabel:String = DEFAULT_TRANSITION_TYPE;		//the label of the transition as it was specified by it's creator.
		protected var _transitionAsset:AbstractAsset;							//the transition applied to this asset
		protected var _transitionCross:Boolean = false;							//is this asset's transition cross between two assets or just switch them ?
		protected var _audioGraph:AudioGraph;									//the audio graph for this asset
		protected var _clipedStreamStart:Number = 0; 							//If the clip has been clipped to be a smaller entry, than this will save the Original Stream Start
		protected var _clipedStreamLen:Number = -1;								//the clipped stream length
		protected var _clipedStreamURL:String = '';								//the url of the stream before clipping
		public var cacheIsSilenceCheck:Boolean = false;							//if the asset is silence, do this check once and than use this value
		public var realSeqStreamSeekTime:Number = 0; 							// This is used to seek the the video/audio/voice Stream to the right place.
		public var startByte:uint = 0;															//the byte offset of where this asset starts in the lage stream (discreteStreams mode)
		public var endByte:uint = 0;																//the byte offset of where this asset ends in the lage stream (discreteStreams mode)
		public var pluginAssetXml:XML = null;
		private var _kalturaEntry:KalturaPlayableEntry;

		public var entrySourceLink:String;
		public var entrySourceCode:int = 0;

		/**
		 * @protected
		 * Presents a thumbnail of the media.
		 * If the media is an flv, by default, the thumbnail will be the frame which the flv's uploader choose to show as a thumbnail.
		 * when the video is edited in the editor, the thumbnail would be the first frame of the cut video (deprecated, too many bugs).
		 */
		//xxx protected var _thumbBitmap:Bitmap = null;
		/**
		 * @protected
		 * used to load the thumbnail image data in order to get thumbnail Bitmap.
		 */
		//xxx protected var _thumbBitmapImage:Image;

		/**
		 * Constructor.
		 * @param asset_uid					the uid of the asset, a unique identifier.
		 * @param entry_id					the entry id, as defined by the server.
		 * @param entry_name				the entry name.
		 * @param thumb_url					the thumbnail url.
		 * @param media_url					the source url of the media object.
		 * @param asset_length				the duration.
		 * @param maximum_length			the maximum duration.
		 * @param start_time				the time stamp to start at.
		 * @param audio_balance				the pan (balance of the asset's audio).
		 * @param transition_type			the type of transition used in the asset.
		 * @param transition_length			the duration of the transition attached to the client.
		 * @param is_focus					is this asset is currently on application focus?.
		 * @param is_selected				is this asset is currently seleceted?.
		 * @param media_source				the media object the asset holds (NetStream, BitmapData, Sound).
		 *
		 */
		public function AbstractAsset( asset_uid:String,
								entry_id:String,
								entry_name:String,
								thumb_url:String,
								media_url:String,
								asset_length:Number,
								maximum_length:Number,
								start_time:Number,
								audio_balance:Number,
								transition_type:String,
								transition_length:Number,
								is_focus:Boolean = false,
								is_selected:Boolean = false,
								media_source:* = null,
								kaltura_entry:KalturaPlayableEntry = null ):void
		{
			_kalturaEntry = kaltura_entry;
/*xxx 			if (_kalturaEntry != null)
				_kalturaEntry.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, dispatchStatusChange, false, 0, true);
 */			_assetUid = asset_uid;
			_entryId = entry_id;
			_entryName = entry_name;
			_thumbnailURL = thumb_url;
			_mediaURL = media_url;
			_length = asset_length;
			_maxLength = maximum_length;
			_startTime = start_time;
			_audioBalance = (audio_balance >= 1) ? 1 : (audio_balance <= 0) ? 0 : audio_balance;
			_focus = is_focus;
			_selected = is_selected;
			_transitionType = (transition_type != "") ? transition_type : DEFAULT_TRANSITION_TYPE;
			_transitionLength = transition_length;
			_mediaSource = media_source;
			_audioGraph = new AudioGraph (_length);
		}

		public function get kalturaEntry ():KalturaPlayableEntry
		{
			return _kalturaEntry;
		}
		public function set kalturaEntry (value:KalturaPlayableEntry):void
		{
			_kalturaEntry = kalturaEntry;
		}

		[Bindable (event="propertyChange")]
		public function get entryStatus ():String
		{
			var mediaUnChecked:uint = MediaTypes.SOLID | MediaTypes.SILENCE | MediaTypes.TRANSITION | MediaTypes.BITMAP_SOCKET | MediaTypes.EFFECT | MediaTypes.OVERLAY | MediaTypes.TEXT_OVERLAY;
			if (mediaType & mediaUnChecked)
				return KalturaEntryStatus.READY;
			if (_kalturaEntry)
				return _kalturaEntry.status;
			else
				return KalturaEntryStatus.PENDING;
		}

/* 		private function dispatchStatusChange (event:PropertyChangeEvent):void
		{
			dispatchEvent (PropertyChangeEvent.createUpdateEvent (this, event.property, event.oldValue, event.newValue));
			if (event.property == "duration")
			{
				_maxLength = _kalturaEntry.duration;
				length = _kalturaEntry.duration;
				_clipedStreamLen = _kalturaEntry.duration;
			}
			trace ("entryId: " + entryId + " changed property " + event.property + " to: " + event.newValue);
		}
 */
		/**
		 *the media source loader, this object monitors the loading of the mediaSource object.
		 * @see com.kaltura.net.loaders.interfaces.IMediaSourceLoader
		 * @see com.kaltura.net.interfaces.ILoadableObject
		 */
		public function get mediaSourceLoader ():IMediaSourceLoader
		{
			return _mediaSourceLoader;
		}
		public function set mediaSourceLoader (ldr:IMediaSourceLoader):void
		{
			_mediaSourceLoader = ldr;
		}

		/**
		 *	Streams are using clipper service, in order to load only the relavent parts of the file, so here we save the original data
		 */
		public function get clipedStreamURL ():String
		{
			return _clipedStreamURL;
		}
		public function set clipedStreamURL (url:String):void
		{
			_clipedStreamURL = url;
		}
		public function get clipedStreamLen ():Number
		{
			return _clipedStreamLen;
		}
		public function set clipedStreamLen (original_stream_length:Number):void
		{
			_clipedStreamLen = original_stream_length;
		}
		public function get clipedStreamStart ():Number
		{
			return _clipedStreamStart;
		}
		public function set clipedStreamStart (original_start_time:Number):void
		{
			_clipedStreamStart = original_start_time;
		}

		/**
		 *This is actiually internal for the player use only.
		 */
		public function get orderBy():Number
		{
			return _orderBy;
		}
		public function set orderBy(newOrderBy:Number):void
		{
			_orderBy = newOrderBy;
		}

		/**
		 *in the editor, the assets are being saved as different arrays (videoArray, audioArray, effectsArray...) and in the player the assets are mixed to one array
		 *this keeps the original index of the asset.
		 */
		public function get originalIndex ():uint
		{
			return _originalIndex;
		}
		public function set originalIndex (idx:uint):void
		{
			_originalIndex = idx;
		}

		/**
		 *the audio graph of this asset.
		 */
		public function get audioGraph ():AudioGraph
		{
			if (!_audioGraph)
				_audioGraph = new AudioGraph (_length);
			return _audioGraph;
		}
		public function set audioGraph (newGraph:AudioGraph):void
		{
			_audioGraph = newGraph;
		}

		/**
		 *the asset's transition plugin.
		 */
		public function get transitionAsset ():AbstractAsset
		{
			return _transitionAsset;
		}
		public function set transitionAsset (k_transition:AbstractAsset):void
		{
			_transitionAsset = k_transition;
		}

		/**
		 *this is the thumbnail of the transition of this asset.
		 */
		public function get transitionThumbnail ():String
		{
			return transitionAsset ? transitionAsset.thumbnailURL : "";
		}
		public function set transitionThumbnail (transition_thumbnail:String):void
		{
			transitionAsset.thumbnailURL = transition_thumbnail;
		}

		/**
		 *is this transition does cross (if true will affect time of this asset and next asset).
		 */
		public function get transitionCross ():Boolean
		{
			return _transitionCross;
		}
		public function set transitionCross (val:Boolean):void
		{
			_transitionCross = val;
		}

		/**
		 *the contributor name of this asset, as stated by the server.
		 */
		public function get entryContributor ():String
		{
			return _entryContributor;
		}
		public function set entryContributor (cnotributor:String):void
		{
			_entryContributor = cnotributor;
		}

		/**
		 * get a cloned bitmapData of this asset thumbnail.
		 */
		public function get thumbBitmap ():Bitmap
		{
/* 			if (_thumbBitmap != null)
			{
				var image:Bitmap = new Bitmap(_thumbBitmap.bitmapData.clone());
				return image;
			} else {
				// if (mediaSource != null && mediaSource is IMediaSource)
				//{
				//	return new Bitmap((mediaSource as IMediaSource).mediaBitmapData.clone());
				//}
				if (mediaType != MediaTypes.SOLID && _thumbBitmapImage == null)
				{
					_thumbBitmapImage = new Image ();
					_thumbBitmapImage.loaderContext = new LoaderContext (true);
					_thumbBitmapImage.autoLoad = false;
					_thumbBitmapImage.addEventListener(Event.COMPLETE, thumbnailLoaded);
					_thumbBitmapImage.addEventListener(IOErrorEvent.IO_ERROR, thumbnailLoadError);
					_thumbBitmapImage.maintainAspectRatio = true;
					_thumbBitmapImage.scaleContent = true;
					_thumbBitmapImage.load(thumbnailURL);
				}
				return null;
			} */
			return null;
		}

		protected function thumbnailLoadError (event:IOErrorEvent):void
		{
			//none here
		}

		protected function thumbnailLoaded (event:Event):void
		{
/* 			var thumbBd:BitmapData = new BitmapData (_thumbBitmapImage.content.width, _thumbBitmapImage.content.height, false, 0);
			thumbBd.draw(_thumbBitmapImage);
			thumbBitmap = new Bitmap(thumbBd);
 */		}

		/**
		 * set the asset's thumbnail bitmapData
		 * @param bmp	bitmapData to set as thumbnail
		 *
		 */
		public function set thumbBitmap (thumbnail_bitmap:Bitmap):void
		{
			//_thumbBitmap = thumbnail_bitmap;
		}

		/**
		 * An abstract function to be overriden by a function which returns this class media data.
		 * @return
		 *
		 */
		public function get mediaSource():*
		{
			return _mediaSource;
		}

		/**
		 *
		 *  An abstract function to be overriden by a function which sets this class media data.
		 * @param srcObj
		 *
		 */
		public function set mediaSource (media_source:*):void
		{
			 _mediaSource = media_source;
		}

		/**
		 *a unique id that represent the asset in the current application instance (used for loading and debugging).
		 */
		public function get assetUID ():String
		{
			return _assetUid;
		}
		public function set assetUID (asset_uid:String):void
		{
			_assetUid = asset_uid;
		}

		/**
		 *the time stamp relative to the overall seqeunce at which the asset starts to play
		 */
		public function get seqStartPlayTime ():Number
		{
			return _seqStartPlayTime;
		}
		public function set seqStartPlayTime (sequenceStartTime:Number):void
		{
			_seqStartPlayTime = sequenceStartTime;
		}

		/**
		 *the time stamp relative to the overall seqeunce at which the asset end to play and is removed
		 */
		public function get seqEndPlayTime ():Number
		{
			return _seqEndPlayTime;
		}
		public function set seqEndPlayTime (sequenceEndTime:Number):void
		{
			_seqEndPlayTime = sequenceEndTime;
		}

		/**
		 *the time stamp relative to the overall seqeunce at which the asset's transition starts to play
		 */
		public function get seqTransitionPlayTime ():Number
		{
			return _seqTransitionPlayTime;
		}
		public function set seqTransitionPlayTime (seqStartTransition:Number):void
		{
			_seqTransitionPlayTime = seqStartTransition;
		}

		/**
		 *the entry id as it is defined by the server, this is a unique identifier of the entry in the server.
		 */
		public function get entryId ():String
		{
			return _entryId;
		}
		public function set entryId (id:String):void
		{
			_entryId = id;
		}

		/**
		 *the entry name as it is defined by the server (contributor in kaltura), this is not unique.
		 */
		public function get entryName ():String
		{
			return _entryName;
		}
		public function set entryName (eName:String):void
		{
			_entryName = eName;
		}

		/**
		 *thumbnail url as it is defined by the server.
		 */
		public function get thumbnailURL ():String
		{
			return _thumbnailURL;
		}

		/**
		 *thumbnail url as it is defined by the server.
		 * @param url	the url of the thumbnail.
		 */
		public function set thumbnailURL (url:String):void
		{
			_thumbnailURL = url;
		}

		/**
		 *the media type of the asset, as it is defined by the constants
		 */
		public function get mediaType ():int
		{
			return _mediaType;
		}
		public function set mediaType (media_type:int):void
		{
			_mediaType = media_type;
		}

		/**
		 * this is the url from which the media object (flv, image file, sound...) will be loaded.
		 */
		public function get mediaURL ():String
		{
			return _mediaURL;
		}
		public function set mediaURL (url:String):void
		{
			_mediaURL = url;
		}

		/**
		 * the duration of the transition attached to this asset.
		 */
		public function set transitionLength (transition_length:Number):void
		{
			if ((transition_length <= _length) && (transition_length >= 0))
			{
				_transitionLength = transition_length;
			}
		}
		public function get transitionLength ():Number
		{
			return _transitionLength;
		}

		/**
		 *the type of the transition attached to this asset.
		 */
		public function set transitionPluginID (transition_type:String):void
		{
			_transitionType = transition_type;
		}
		public function get transitionPluginID ():String
		{
			return _transitionType;
		}

		/**
		 *the label of theis asset's transition.
		 */
		public function get transitionLabel ():String
		{
			var plugin:Plugin = _transitionAsset != null ? (_transitionAsset.mediaSource as Plugin) : null;
			if (plugin)
				return plugin.label;
			else
				return _transitionLabel;
		}
		public function set transitionLabel (label:String):void
		{
			_transitionLabel = label;
		}

		/**
		 *the pan (Balance) of the audio.
		 */
		public function set audioBalance (balance:Number):void
		{
			_audioBalance = (balance >= 1) ? 1 : (balance <= -1) ? -1 : balance;
		}
		public function get audioBalance ():Number
		{
			return _audioBalance;
		}

		/**
		 *indicates if this asset has application focus on it.
		 */
		public function set focus (f:Boolean):void
		{
			_focus = f;
		}
		public function get focus ():Boolean
		{
			return _focus;
		}

		/**
		 *indicates if the asset is currently selected (opposed to focus, as an asset can be selected as part of collection).
		 */
		public function set selected (is_selected:Boolean):void
		{
			_selected = is_selected;
		}
		public function get selected ():Boolean
		{
			return _selected;
		}

		/**
		 *the time stamp inside the asset from which the asset should play.
		 */
		public function set startTime (stime:Number):void
		{
			if (stime < 0)
			{
				stime = 0;
			}
			if (stime > _maxLength)
			{
				stime = _maxLength;
			}
			if (audioGraph.graphCollection.length > 0)
			{
				var pY:Number = audioGraph.graphCollection.getItemAt(0).y;
				if (audioGraph.graphCollection.getItemAt(0).x != 0)
				{
					audioGraph.graphCollection.addItemAt(new Point(0, pY), 0); 	//reset the first point
																//the first point is always at 0! mind that
				}
			}
			if (audioGraph.graphCollection.length <= 1)
					audioGraph.setOverallVolume(0.5);										//_startTime is the time to start on the real stream
			//xxx audioGraph.graphCollection.refresh();
			//set the new starttime
			_startTime = stime;
		}
		public function get startTime ():Number
		{
			return _startTime;
		}

		/**
		 * the length of the asset.
		 * @param len	the length of the asset.
		 *
		 */
		public function set length (len:Number):void
		{
			if (len < 0)
			{
				len = 0;
			}
			if (len > _maxLength && (_mediaType == MediaTypes.AUDIO || _mediaType == MediaTypes.VIDEO))
			{
				len = _maxLength;
			}
			audioGraph.length = len;
			//set the new length
			_length = len;
		}
		public function get length ():Number
		{
			return _length;
		}

		/**
		 * Sets this asset's maximum length in seconds.
		 * May be overriden by classes whose max length cannot be change.
		 * @param maxLen	duration of the asset
		 */
		public function set maxLength (maxLen:Number):void
		{
				_maxLength = maxLen;
		}
		public function get maxLength ():Number
		{
			return _maxLength;
		}

		/**
		 * generate a string description of the asset
		 * @return 	string description
		 *
		 */
		override public function toString():String
		{
			return String("type: " + _mediaType + "  id: " + _assetUid + ", Name: " + _entryName + ", Start: " + _startTime +
					", Len: " + _length + ", Max: " + _maxLength +
					", Ttype: " + _transitionType + ", TransitionLen: " + _transitionLength);
		}

		/**
		 *disposes of the object from memory.
		 *
		 */
		public function dispose ():void
		{
			if (_transitionAsset)
				_transitionAsset.dispose();
			_transitionAsset = null;
			if (_mediaSourceLoader)
			{
				_mediaSourceLoader.dispose ();
			} else {
				if (_mediaSource)
				{
					if (_mediaSource is IDisposable)
						_mediaSource.dispose ();
					_mediaSource = null;
				}
			}
			_mediaSourceLoader = null;
			if (_audioGraph != null)
				_audioGraph.dispose();
			_audioGraph = null;
		}

		public function clone ():AbstractAsset
		{
			var newAsset:AbstractAsset = AssetsFactory.create (_mediaType, "", _entryId,
															_entryName, _thumbnailURL, _mediaURL, _length,
															_maxLength, _startTime, _audioBalance, _transitionType, _transitionLength,
															false, false, null, _kalturaEntry);
			newAsset.kalturaEntry = kalturaEntry;
			newAsset.clipedStreamURL = _clipedStreamURL;
			newAsset.clipedStreamStart = _clipedStreamStart;
			newAsset.clipedStreamLen = _clipedStreamLen;
			_audioGraph.copy(newAsset.audioGraph);
			newAsset.entryContributor = _entryContributor;
			newAsset.thumbBitmap = thumbBitmap;
			newAsset.entryContributor = entryContributor;
			newAsset.entrySourceCode = entrySourceCode;
			newAsset.entrySourceLink = entrySourceLink;
			newAsset.transitionCross = transitionCross;
			newAsset.transitionLabel = transitionLabel;
			newAsset.transitionLength = transitionLength;
			newAsset.transitionPluginID = transitionPluginID;
			newAsset.transitionThumbnail = transitionThumbnail;
			return newAsset;
		}
	}
}