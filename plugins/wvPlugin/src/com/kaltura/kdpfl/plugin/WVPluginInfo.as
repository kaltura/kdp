package com.kaltura.kdpfl.plugin
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;
	
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactoryItem;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.PluginInfo;
	
	public class WVPluginInfo extends PluginInfo implements IEventDispatcher
	{
		
		private var _dispatcher:EventDispatcher;
		/**
		 * Width of media
		 * @default 400  
		 */		
		public static var mediaWidth:Number = 400;
		/**
		 * height of media
		 * @default 300  
		 */		
		public static var mediaHeight:Number = 300;

		/**
		 * This event type will notify a new wvMediaElement was created 
		 */		
		public static const WVMEDIA_ELEMENT_CREATED:String = "wvElementCreated";
		
		private var _wvMediaElement:WVMediaElement;

		
		public function WVPluginInfo(mediaFactoryItems:Vector.<MediaFactoryItem>=null, mediaElementCreationNotificationFunction:Function=null)
		{
			_dispatcher = new EventDispatcher();
			var mediaInfo : MediaFactoryItem = new MediaFactoryItem("com.kaltura.kdpfl.plugin.WVMediaElement", canHandleResource, createWVMediaElement );
			mediaFactoryItems = new Vector.<MediaFactoryItem>;
			mediaFactoryItems.push(mediaInfo);
			super(mediaFactoryItems, mediaElementCreationNotificationFunction);
		}
		
		public function get wvMediaElement():WVMediaElement
		{
			return _wvMediaElement;
		}

		public function canHandleResource (resource:MediaResourceBase) : Boolean
		{
			if (resource.hasOwnProperty("url") && resource["url"].toString().indexOf(".wvm") > -1)
			{
				try
				{
					ExternalInterface.call("mediaURL" , resource["url"].toString());
				} 
				catch(error:Error) 
				{
					trace("Failed to call external interface");
				}
				return true;
			}
			return false;
		}

		
		protected function createWVMediaElement () : MediaElement
		{
			_wvMediaElement = new WVMediaElement(mediaWidth,mediaHeight);
			dispatchEvent(new Event(WVMEDIA_ELEMENT_CREATED));
			return wvMediaElement;
		}
		
		// ==============================================
		// IEventDispatcher methods
		// ==============================================

		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _dispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _dispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _dispatcher.willTrigger(type);
		}
		// ==============================================

	}
}