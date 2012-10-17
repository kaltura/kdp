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
package com.kaltura.plugin.layer
{
	import com.kaltura.net.nonStreaming.SWFLoaderMediaSource;
	import com.kaltura.net.streaming.ExNetStream;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.media.Video;

	/**
	 * Wrapper of video and bitmap that provides an easy interface for the player to manage visual layers.
	 * @author Zohar Babin
	 *
	 */
	public class VSPair extends Layer
	{
		/**
		 *a container for the video instance.
		 */
		private var vidContainer:Sprite;
		/**
		 *sprite container to hold the video and image instances.
		 */
		private var childrenContainer:Sprite;
		/**
		 *the video netstream.
		 */
		private var netStream:ExNetStream;
		/**
		 *keeps copies of bitmaps so that the player doesn't lock the assets bitmaps.
		 */
		private var bmd:BitmapData;
		/**
		 * bitmap for images.
		 */
		private var bmp:Bitmap;
		/**
		 *container to hold the bitmaps.
		 */
		private var bmpContainer:Sprite;
		/**
		 *container to hold the swf.
		 */
		private var swfContainer:Sprite;
		/**
		 * originial width of the player.
		 */
		private var startW:Number;
		/**
		 * original height of the player.
		 */
		private var startH:Number;

		/**
		 *Constructor.
		 * @param playerWidth		the original width of the player.
		 * @param playerHeight		the original height of the player.
		 */
		public function VSPair (playerWidth:Number, playerHeight:Number):void
		{
			super(true, playerWidth, playerHeight);
			startW = playerWidth;
			startH = playerHeight;
			bmpContainer = new Sprite ();
			swfContainer = new Sprite ();
			vidContainer = new Sprite ();
			childrenContainer = new Sprite ();
			bmd = new BitmapData (playerWidth, playerHeight, true, 0);
			bmp = new Bitmap (bmd);
			bmpContainer.addChild (bmp);
			childrenContainer.addChild (bmpContainer);
			childrenContainer.addChild (swfContainer);
			childrenContainer.addChild (vidContainer);
			display.addChildAt (childrenContainer, 1);
			bmpContainer.graphics.beginFill(0);
			bmpContainer.graphics.drawRect(0, 0, playerWidth, playerHeight);
			bmpContainer.width = playerWidth;
			bmpContainer.height = playerHeight;
			swfContainer.graphics.beginFill(0);
			swfContainer.graphics.drawRect(0, 0, playerWidth, playerHeight);
			swfContainer.width = playerWidth;
			swfContainer.height = playerHeight;
			vidContainer.graphics.beginFill(0);
			vidContainer.graphics.drawRect(0, 0, playerWidth, playerHeight);
			vidContainer.width = playerWidth;
			vidContainer.height = playerHeight;
		}

		/**
		 *clears the video container from current video.
		 */
		private function clearVidContainer ():void
		{
			while (vidContainer.numChildren > 0)
				vidContainer.removeChildAt(0);
			if (netStream != null)
				netStream.pauseMedia();
			netStream = null;
		}

		/**
		 * a new netstream instance and adds its video to the video container.
		 */
		public function get stream():ExNetStream
		{
			return netStream;
		}
		public function set stream(new_stream:ExNetStream):void
		{
			clearVidContainer ();
			netStream = new_stream;
			bmpContainer.visible = false;
			swfContainer.visible = false;
			vidContainer.visible = true;
			if (netStream.streamVideo)
			{
				var resizeRect:Object = rescaleContent (netStream.streamVideo.width, netStream.streamVideo.height);
				netStream.streamVideo.width = resizeRect.w;
				netStream.streamVideo.height = resizeRect.h;
				netStream.streamVideo.x = resizeRect.x;
				netStream.streamVideo.y = resizeRect.y;
				vidContainer.addChild(netStream.streamVideo);
			}
		}

		public function rescaleContent (source_width:Number, source_height:Number):Object
		{
			if (source_width == 0 || source_height == 0)
			{
				return {x:0, y:0, w:startW, h:startH};
			}
			var pw:Number = parent.parent.parent.width;
			var ph:Number = parent.parent.parent.height;
			var w:Number = pw;
			var h:Number = ph;
			var rw:Number = source_width / w;
			var rh:Number = source_height / h;
			if (rw > rh)
			{
				h = source_height / rw;
			} else {
				w = source_width / rh;
			}
			var target_width:Number = w * startW / pw;
			var target_height:Number = h * startH / ph;
			var target_x:Number = (startW - target_width) / 2;
			var target_y:Number = (startH - target_height) / 2;
			return {x:target_x, y:target_y, w:target_width, h:target_height};
		}

		/**
		 *reference to the current video instance.
		 */
		public function get video():Video
		{
			if (netStream)
				return netStream.streamVideo;
			return null;
		}

		/**
		 * sets a new bitmapdata to present in the image container.
		 */
		public function set imageBD (src_image:BitmapData):void
		{
			if (src_image)
			{
				clearVidContainer();
				bmpContainer.visible = true;
				swfContainer.visible = false;
				vidContainer.visible = false;
				bmd = src_image;
				var resizeRect:Object = rescaleContent (bmd.width, bmd.height);
				bmp.smoothing = true;
				bmp.bitmapData = bmd;
				bmp.width = resizeRect.w;
				bmp.height = resizeRect.h;
				bmp.x = resizeRect.x;
				bmp.y = resizeRect.y;
			} else {
				clearVideo();
			}
		}

		public function set SWF (source:SWFLoaderMediaSource):void
		{
			clearVidContainer();
			swfContainer.visible = true;
			bmpContainer.visible = false;
			vidContainer.visible = false;
			if (source.content)
				swfContainer.addChild(source.content);
		}

		/**
		 * clears the screen (generates black frame).
		 */
		public function clearVideo():void
		{
			clearVidContainer();
			// when drawing empty ui, you get the last drawen bmd, than reset to black bmd.
			bmd.fillRect(bmd.rect, 0);
			bmp.bitmapData = bmd;
			while (swfContainer.numChildren > 0)
				swfContainer.removeChildAt(0);
		}
	}
}