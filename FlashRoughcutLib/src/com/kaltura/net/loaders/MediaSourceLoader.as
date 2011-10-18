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
package com.kaltura.net.loaders
{
	import com.kaltura.net.downloading.LoadingStatus;
	import com.kaltura.net.interfaces.ILoadableObject;
	import com.kaltura.net.loaders.interfaces.IMediaSourceLoader;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;

	public class MediaSourceLoader extends EventDispatcher implements IMediaSourceLoader
	{
		protected var _url:String;
		protected var _uid:String;
		protected var _status:int;
		protected var _totalBytes:uint;
		protected var _bytesLoaded:uint;
		protected var _loadedObject:ILoadableObject;

		/**
		 *Constructor.
		 * @param loaded_object		the ILoadableObject to monitor.
		 * @param asset_uid			the uid of the asset whos media to load.
		 * @param asset_url			the url of the media to load.
		 * @see com.kaltura.net.interfaces.ILoadableObject
		 */
		public function MediaSourceLoader(loaded_object:ILoadableObject, asset_uid:String, asset_url:String):void
		{
			super();
			_uid = asset_uid;
			_url = asset_url;
			_loadedObject = loaded_object;
			_status = ((loadedObject.bytesLoaded < loaded_object.bytesTotal) || (loadedObject.bytesLoaded == 0)) ? LoadingStatus.PROGRESS : LoadingStatus.COMPLETE;
			_loadedObject.addEventListener(Event.COMPLETE, completeHandle, false, 0, true);
			_loadedObject.addEventListener("error", errorHandle, false, 0, true);
			_loadedObject.addEventListener(ProgressEvent.PROGRESS, progressHandle, false, 0, true);
		}

		public function clone ():IMediaSourceLoader
		{
			var newLoader:IMediaSourceLoader;
			newLoader = new MediaSourceLoader (_loadedObject, _uid, _url);
			return newLoader;
		}

		protected function progressHandle (e:ProgressEvent):void
		{
			dispatchEvent(e.clone());
		}

		protected function errorHandle (e:Event):void
		{
			_status = LoadingStatus.ERROR;
			dispatchEvent(e.clone());
		}

		protected function completeHandle (e:Event):void
		{
			_status = LoadingStatus.COMPLETE;
			dispatchEvent (e.clone());
		}

		/**
		 * @return the unique identifier of this object.
		 */
		public function get uid():String
		{
			return _uid;
		}

		/**
		 * @return the loading status.
		 */
		public function get status():int
		{
			if (_status == LoadingStatus.PROGRESS && ((_loadedObject.bytesLoaded >= _loadedObject.bytesTotal) && (_loadedObject.bytesLoaded > 0)))
			{
				_status = LoadingStatus.COMPLETE;
			}
			return _status;
		}

		/**
		 * @return the percentage of the loading status.
		 */
		[Bindable(event="progress")]
		public function get percentLoaded():Number
		{
			return _loadedObject.bytesLoaded / _loadedObject.bytesTotal * 100;
		}

        /**
         * @return the total bytes.
         */
		public function get totalBytes():uint
		{
			return _loadedObject.bytesTotal;
		}

		/**
		 * @return the bytesLoaded.
		 */
		public function get bytesLoaded():uint
		{
			return _loadedObject.bytesLoaded;
		}

		/**
		 * @return the url that is loaded.
		 */
		public function get url():String
		{
			return _url;
		}

		/**
		 * @return the media source (LoaderDisplayObject, ExNetStream...) attached.
		 */
		public function get loadedObject():ILoadableObject
		{
			return _loadedObject;
		}

		/**
		 * reloads the data.
		 */
		public function reload():void
		{
			_totalBytes = _loadedObject.bytesTotal;
			_bytesLoaded = _loadedObject.bytesLoaded;
			_status = LoadingStatus.PROGRESS;
		}

		/**
		 *disposes of this object from memory.
		 *
		 */
		public function dispose():void
		{
			if (_loadedObject)
				_loadedObject.dispose ();
			_loadedObject = null;
		}
	}
}