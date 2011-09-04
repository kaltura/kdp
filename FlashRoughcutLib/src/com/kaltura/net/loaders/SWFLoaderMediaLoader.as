package com.kaltura.net.loaders
{
	import com.kaltura.net.interfaces.ILoadableObject;
	import com.kaltura.net.interfaces.IMediaSource;
	import com.kaltura.net.nonStreaming.SWFLoaderMediaSource;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;

	public class SWFLoaderMediaLoader extends EventDispatcher implements ILoadableObject
	{
		private var swfloader:SWFLoaderMediaSource;

		public function SWFLoaderMediaLoader(url:String, type:String = "", playerWidth:Number = 640, playerHeight:Number = 480):void
		{
			super();
			swfloader = new SWFLoaderMediaSource ();
			swfloader.addEventListener(Event.COMPLETE, completed);
			swfloader.addEventListener(ProgressEvent.PROGRESS, progress);
			//xxx swfloader.load(url);
		}

		protected function completed (event:Event):void
		{
			dispatchEvent(event.clone());
		}
		protected function progress (event:Event):void
		{
			dispatchEvent(event.clone());
		}

		public function dispose():void
		{
			swfloader.dispose();
		}

		public function get bytesLoaded():uint
		{
			return 0;//xxx 
			//xxx return swfloader.bytesLoaded;
		}

		public function get bytesTotal():uint
		{
			return 0;//xxx 
			//xxx return swfloader.bytesTotal;
		}

		public function get mediaSource():IMediaSource
		{
			return swfloader;
		}
	}
}