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
package com.kaltura.managers.downloadManagers.imagesManager
{
	import com.kaltura.dataStructures.HashMap;
	import com.kaltura.dataStructures.IMap;
	import com.kaltura.net.loaders.MediaSourceLoader;
	import com.kaltura.net.loaders.interfaces.IMediaSourceLoader;
	import com.kaltura.net.nonStreaming.LoaderDisplayObject;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Event(name="complete", type="flash.events.Event")]

	/**
	 * Singleton manager class that provides Images loading and manage LoaderDisplayObject's of the loaded images.
	 * when loading the same image, the manager will return the LoaderDisplayObject saved.
	 */
	public class ImagesManager extends EventDispatcher
	{
		/**
		* a single instance of the ImagesManager class.
		*/
		protected static var instance:ImagesManager = new ImagesManager ();

		/**
		* A hash table that holds all the loaded images LoaderDisplayObject.
		*/
		protected var _table:IMap = new HashMap();

		/**
		 * Creates new ImagesManager.
		 * Since ImagesManager is a singleton class, it can only be instantiated once by the getInstance() method.
		 */
		public function ImagesManager():void
		{
			//singleton check
			if( instance ) throw new Error( "ImagesManager can only be accessed through ImagesManager.getInstance()" );
		}

		/**
		 * getInstance method for the singleton.
		 * @return the only instance of this class.
		 *
		 */
		public static function getInstance():ImagesManager
		{
			return instance;
		}

		/**
		 *creates loadStream and load the image.
		 * @param image_url		the url to load.
		 * @param asset_uid		the uid of the asset it's media to load.
		 * @return 				the loadStream of the loaded image, if image is already loaded, return the saved loadStream.
		 * @see			com.kaltura.net.nonStreaming.LoaderDisplayObject
		 */
		public function create(image_url:String, asset_uid:String):IMediaSourceLoader
		{
			var imgLS:IMediaSourceLoader = _table.getValue(image_url);

			if (imgLS != null)
			{
				try {
					var newImgLdr:IMediaSourceLoader = imgLS.clone();
					return newImgLdr;
				} catch (err:Error) {

				}
			}

			imgLS = new MediaSourceLoader (new LoaderDisplayObject (image_url), asset_uid, image_url);
			_table.put(image_url, imgLS);
			return imgLS;
		}

		/**
		 *removes an image from the table, dispose it from memory.
		 * @param image_url			the url of the cached image to dispose.
		 */
		public function removeImage (image_url:String):void
		{
			_table.remove (image_url);
		}
	}
}