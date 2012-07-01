/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.example.views
{
	import com.adobe.webapis.flickr.Photo;
	import com.yahoo.astra.animation.Animation;
	
	import fl.containers.UILoader;
	import fl.core.UIComponent;
	import fl.events.ComponentEvent;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;

	public class ImageResult extends UIComponent
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		public function ImageResult()
		{
			super();
			
			this.alpha = 0;
			this.tabEnabled = true;
			
			this.imageLoader.scaleContent = false;
			this.imageLoader.buttonMode = true;
			this.imageLoader.addEventListener(IOErrorEvent.IO_ERROR, imageErrorHandler);
			this.imageLoader.addEventListener(MouseEvent.CLICK, imageClickHandler);
			this.imageLoader.addEventListener(Event.COMPLETE, imageCompleteHandler);
			this.imageLoader.addEventListener(ComponentEvent.RESIZE, imageResizeHandler);
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		public var imageLoader:UILoader;
		public var titleField:TextField;
		public var userField:TextField;
		
		protected var dataChanged:Boolean = false;
		
		private var _flickrData:Photo;
		
		public function get flickrData():Photo
		{
			return this._flickrData;
		}
		
		public function set flickrData(value:Photo):void
		{
			this._flickrData = value;
			this.dataChanged = true;
			this.invalidate();
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
	
		
		override protected function draw():void
		{
			super.draw();
			
			if(this.dataChanged)
			{
				if(this.flickrData)
				{
					var url:String = "http://static.flickr.com/" + this.flickrData.server + "/" + this.flickrData.id + "_" + this.flickrData.secret + "_t.jpg";
					this.imageLoader.source = url;
					this.titleField.text = this.flickrData.title ? this.flickrData.title : "Untitled";
					this.userField.text = "By " + (this.flickrData.ownerName ? this.flickrData.ownerName : "Unknown") + " on Flickr";
				}
				else
				{
					this.imageLoader.source = null;
					this.titleField.text = "No Data";
					this.userField.text = "";
				}
				this.dataChanged = false;
			}
		}
		
		protected function imageCompleteHandler(event:Event):void
		{
			Animation.create(this, 150, {alpha: 1.0});
			
		}
		
		protected function imageErrorHandler(event:IOErrorEvent):void
		{
			//TODO: do something on error
		}
		
		protected function imageResizeHandler(event:ComponentEvent):void
		{
			this.imageLoader.x = (this.width - this.imageLoader.width) / 2;
			this.imageLoader.y = this.titleField.y - this.imageLoader.height + 1;
		}
		
		/**
		 * @private
		 * When someone clicks on a result, go to the Flickr page for that image.
		 */
		protected function imageClickHandler(event:MouseEvent):void
		{
			var url:String = "http://www.flickr.com/photos/" + this.flickrData.ownerId + "/" + this.flickrData.id;
			navigateToURL(new URLRequest(url));
		}
	}
}