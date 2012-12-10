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
package com.kaltura.net.nonStreaming
{
	import com.kaltura.net.downloading.LoadingStatus;
	import com.kaltura.net.interfaces.ILoadableObject;
	import com.kaltura.net.interfaces.IMediaSource;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class LoaderDisplayObject extends EventDispatcher implements IMediaSource, ILoadableObject
	{
		private const meName:String = "LoderDisplayObject";
		protected var _imageName:String = "";
		protected var _url:String = "";
		protected var _data:ByteArray;
		protected var _urlLoader:URLLoader;
		protected var _loader:Loader;
		protected var _type:String;
		protected var _percentageLoaded:uint = 0;
		protected var _bytesLoaded:uint = 0;
		protected var _bytesTotal:uint = 0;
		protected var _loadStatus:int;
		protected var _bd:BitmapData = null;
		protected var explicitWidth:Number;
		protected var explicitHeight:Number;
		protected var backDrawBmp:Bitmap = new Bitmap ();								//bitmapt to rescale the loaded image b4 it's displayed
		protected var ImgMat:Matrix = new Matrix ();

		/**
		 *Constructor.
		 * @param url				the url to load.
		 * @param type				the type of the loaded object.
		 * @param playerWidth		the width to rescale the loaded image to.
		 * @param playerHeight		the height to rescale the loaded image to.
		 *
		 */
		public function LoaderDisplayObject(url:String, type:String = "", playerWidth:Number = 640, playerHeight:Number = 480):void
		{
			_url = url;
			explicitWidth = playerWidth;
			explicitHeight = playerHeight;
			_type = type;
			var tempN:Array = url.split("/");
			_imageName = tempN[(tempN.length - 1)];
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			configureListeners (_urlLoader);
			_urlLoader.load (new URLRequest(url));
		}

		public function get mediaSource ():IMediaSource
		{
			return this;
		}

		/**
		 *register the listeners for the Loader object.
		 * @param dispatcher	Loader object.
		 * @private
		 */
		private function configureListeners(dispatcher:IEventDispatcher):void
		{
			dispatcher.addEventListener(Event.COMPLETE, onBytesLoaded);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(Event.INIT, initHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(Event.UNLOAD, unLoadHandler);
        }

        public function get bytesLoaded ():uint
        {
        	return _bytesLoaded;
        }

        public function get bytesTotal ():uint
        {
        	return _bytesTotal;
        }

        /**
         *loads the image.
         */
        protected function load():void
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, makeBitmapData);
			_loader.loadBytes(_data);
		}

		/**
		 *the name of the image loaded.
		 */
		public function get imageName():String
		{
			return _imageName;
		}

		/**
		 *the loader of the image.
		 */
		public function get loader():Loader
		{
			return _loader;
		}

		/**
		 *byteArray that holds the data of the loaded image.
		 */
		public function get data():ByteArray
		{
			return _data;
		}

        /**
         *copy the bitmapdata of the loaded image.
         * @return 	a clone of the loaded bitmapData.
         *
         */
        public function get mediaBitmapData ():BitmapData
        {
        	if (_loadStatus == LoadingStatus.COMPLETE)
        	{
	        	var returnBd:BitmapData = null;
	        	try {
		        	if (_bd)
		        		returnBd = _bd.clone();
		        } catch (e:Error) {
		        	return null;
		        }
	        	return returnBd;
	        } else {
	        	return null;
	        }
        }

		/**
		 *preformed when Loader finished download.
		 * @param event
		 *
		 */
		protected function onBytesLoaded(event:Event):void
		{
			if (_urlLoader)
			{
				_data = _urlLoader.data;
				if (_data.length > 0)
					load();
				else
					trace ("error loading: " + _url);
			}
		}

		/**
		 *when the image finished loading and instantiation, rescale it and save it's bitmapData.
		 */
		protected function makeBitmapData(event:Event):void
		{
			/*var Holder:Sprite = new Sprite ();
			var g:Graphics = Holder.graphics;
			g.lineStyle (0, 0, 1);
			g.beginFill (0, 1);
			g.drawRect (0, 0, explicitWidth, explicitHeight);
			g.endFill();
			Holder.width = explicitWidth;
			Holder.height = explicitHeight;
			var w:Number;
			var h:Number;
			var r:Number;
			//if we need to enlarge the width or the height of the image by at least 4 times it's original size, than keep it's original size.
			var rw:Number = explicitWidth / _loader.content.width;
			var rh:Number = explicitHeight / _loader.content.height;
			if (rw < 4 || rh < 4)
			{
				//resize the image relative:
				if (_loader.content.width > _loader.content.height)
				{
					r = _loader.content.height / _loader.content.width;
					w = explicitWidth;
					h = r * explicitWidth;
				} else {
					r = _loader.content.width / _loader.content.height;
					h = explicitHeight;
					w = r * explicitHeight;
				}
			} else {
				w = _loader.content.width;
				h = _loader.content.height;
			}
			_loader.content.width = w;
			_loader.content.height = h;
			Holder.addChild (_loader.content);
			var tx:Number = (Holder.width - _loader.content.width) / 2;
			var ty:Number = (Holder.height - _loader.content.height) / 2;
			_loader.content.x = tx;
			_loader.content.y = ty;
			var tempBD:BitmapData = new BitmapData(Holder.width, Holder.height, false, 0);
			tempBD.draw (Holder, null, null, null, null, true);

			backDrawBmp.bitmapData = tempBD;					// take the loaded image to back buffer (bitmap)
			var Sx:Number = explicitWidth / backDrawBmp.bitmapData.width;
			var Sy:Number = explicitHeight / backDrawBmp.bitmapData.height;
			ImgMat = new Matrix();
			ImgMat.scale(Sx, Sy);
			_bd = new BitmapData (explicitWidth, explicitHeight, true, 0);
			_bd.draw (backDrawBmp, ImgMat, null, null, null, true);	//than draw it again, rescaled by the dimention wanted
			*/
			if (_loader.content is Bitmap)
			{
				_bd = _loader.content['bitmapData'].clone ();
				_loadStatus = LoadingStatus.COMPLETE;
				dispatchEvent(new Event (Event.COMPLETE));
			} else {
				onErrorFailQuite ();
			}
		}

        /**
         *handler for Loader init
         */
        protected function initHandler(event:Event):void
        {
        	//don't do anything here
        }

        /**
         *handler for Loader open
         */
        protected function openHandler(event:Event):void
        {
        	//don't do anything here
        }

		/**
		 *handler for Loader HttpStatus error
		 */
		protected function httpStatusHandler(event:HTTPStatusEvent):void
        {
        	//removed this, if there are http statuses we should concider, please fill it in...
        	//onErrorFailQuite ();
        }

        /**
         *handler for Loader IOError
         */
        protected function ioErrorHandler(event:IOErrorEvent):void
        {
        	onErrorFailQuite ();
        }

        /**
         * called on loading error.
         */
        protected function onErrorFailQuite ():void
        {
        	_bd = new BitmapData (explicitWidth, explicitHeight, true, 0);
        	dispatchEvent(new Event ("error"));
        }

        /**
         *progress of loading.
         */
        protected function progressHandler(event:ProgressEvent):void
        {
        	dispatchEvent (new ProgressEvent(ProgressEvent.PROGRESS, false, false, event.bytesLoaded, event.bytesTotal));
        	_percentageLoaded = uint(event.bytesLoaded / event.bytesTotal * 100);
        	_bytesLoaded = event.bytesLoaded;
        	_bytesTotal = event.bytesTotal;
        }

        /**
         *called when un load has occured on the loader.
         */
        protected function unLoadHandler (e:Event):void
        {
        	//do nothing.
        }

        /**
         *not used in this mediaSource type.
         */
        public function pauseMedia ():void
        {
        	//do nothing.
        }

        /**
         *not used in this mediaSource type.
         */
        public function playMedia ():void
        {
        	//do nothing.
        }

        /**
         *not used in this mediaSource type.
         */
        public function seekMedia (offset:Number, originalStart:Number = -1, nearestNext:Boolean = false):void
        {
        	//do nothing.
        }

        /**
        * disposes of the object
        */
        public function dispose ():void
        {
			if (_data != null)
				_data = null;
			if (_urlLoader != null)
				_urlLoader = null;
			if (_loader != null)
				_loader = null;
			if (_bd != null)
			_bd.dispose();
        }
	}
}