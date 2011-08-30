package com.kaltura.kdpfl.plugin
{
	import com.kaltura.osmf.kaltura.WVMediaResource;
	
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactoryItem;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.PluginInfo;
	import org.osmf.media.URLResource;
	
	public class WVPluginInfo extends PluginInfo
	{
		
		public function WVPluginInfo(mediaFactoryItems:Vector.<MediaFactoryItem>=null, mediaElementCreationNotificationFunction:Function=null)
		{
			var mediaInfo : MediaFactoryItem = new MediaFactoryItem("com.kaltura.kdpfl.plugin.WVMediaElement", canHandleResource, createWVMediaElement );
			mediaFactoryItems = new Vector.<MediaFactoryItem>;
			mediaFactoryItems.push(mediaInfo);
			super(mediaFactoryItems, mediaElementCreationNotificationFunction);
		}
		
		public function canHandleResource (resource:MediaResourceBase) : Boolean
		{
			if (resource is WVMediaResource)
			{
				return true;
			}
			return false;
		}

		
		protected function createWVMediaElement () : MediaElement
		{
			return new WVMediaElement();
		}

	}
}