package com.kaltura.osmf.kontiki
{
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactoryItem;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.PluginInfo;
	
	public class KontikiPluginInfo extends PluginInfo
	{
		public var jsToCall:String;
		
		public function KontikiPluginInfo(mediaFactoryItems:Vector.<MediaFactoryItem>=null, mediaElementCreationNotificationFunction:Function=null)
		{
			var mediaInfo : MediaFactoryItem = new MediaFactoryItem("com.kaltura.osmf.kontiki.KontikiElement", canHandleResource, createKontikiMediaElement );
			mediaFactoryItems = new Vector.<MediaFactoryItem>;
			mediaFactoryItems.push(mediaInfo);
			super(mediaFactoryItems, mediaElementCreationNotificationFunction);
		}
		
		protected function createKontikiMediaElement():MediaElement
		{
			var newElement :KontikiElement = new KontikiElement();
			newElement.jsToCall = jsToCall;
			return newElement;
		}
		
		/**
		 * checks whether the plugin can handle a resource  
		 * @param resource	resource to check
		 * @return true if the plugin can handle the given resource 
		 */		
		public function canHandleResource(resource:MediaResourceBase):Boolean
		{
			if (resource && resource.hasOwnProperty("url") && resource["url"].toString().indexOf("urn:kid") != -1)
			{			
				return true;
			}
			
			return false
		}
	}
}