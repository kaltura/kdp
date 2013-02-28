package com.kaltura.kdpfl.plugin
{
	import flash.external.ExternalInterface;
	
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactoryItem;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.PluginInfo;
	import org.osmf.media.URLResource;
	
	public class WVPluginInfo extends PluginInfo
	{
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
		
		private var _wvMediaElement:WVMediaElement;
		
		//public var shouldHandleResource:Boolean = false;
		//public var wvAssetId:String;
		
		public function WVPluginInfo(mediaFactoryItems:Vector.<MediaFactoryItem>=null, mediaElementCreationNotificationFunction:Function=null)
		{
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
			_wvMediaElement = new WVMediaElement(mediaWidth,mediaHeight)
			return wvMediaElement;
		}

	}
}