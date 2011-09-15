package com.kaltura.net.nonStreaming
{
	import com.kaltura.net.interfaces.IMediaSource;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundTransform;

	//import mx.controls.SWFLoader;
	//import mx.core.ApplicationGlobals;

	//xxx public class SWFLoaderMediaSource extends SWFLoader implements IMediaSource
	public class SWFLoaderMediaSource extends EventDispatcher implements IMediaSource
	{
		public var soundTransform:SoundTransform; //xxx
		public var content:Sprite; //xxx
		
		public function SWFLoaderMediaSource():void
		{
			super ();
			addEventListener(Event.COMPLETE, loadComplete);
			addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
		}

		protected function errorHandler (event:Event):void
		{
			//xxx trace ('couldn\'t load ' + source);
		}

		public function dispose():void
		{
			removeEventListener(Event.COMPLETE, loadComplete);
			//xxx load (null);
		}

		private function loadComplete (event:Event):void
		{
/* 			try {
				var app:Object = ApplicationGlobals.application;
				var parameters:Object;
				if (app.hasOwnProperty('manager') && app.manager.hasOwnProperty('kdpModel')) {
					parameters = app['manager']['kdpModel'];
				} else {
					parameters = app.parameters;
				}
				content['startApp'](parameters);
			} catch (err:Error) {}
 */		}

		public function playMedia():void
		{
/* 			try {
				content['playMedia']();
			}catch (err:Error) {}
 */		}

		public function pauseMedia():void
		{
/* 			try {
				content['pauseMedia']();
			}catch (err:Error) {}
 */		}

		public function seekMedia (offset:Number, original:Number = -1, direction:Boolean = false):void
		{
/* 			try {
				content['seekMedia'](offset, original, direction);
			}catch (err:Error) {}
 */		}

		public function get mediaBitmapData():BitmapData
		{
			return null;
		}

	}
}