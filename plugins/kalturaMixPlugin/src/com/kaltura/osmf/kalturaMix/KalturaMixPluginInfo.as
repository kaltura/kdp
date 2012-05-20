package com.kaltura.osmf.kalturaMix
{
	import __AS3__.vec.Vector;
	
	import com.kaltura.osmf.kaltura.KalturaBaseEntryResource;
	import com.kaltura.vo.KalturaMixEntry;
	
	import flash.errors.IllegalOperationError;
	
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactoryItem;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.PluginInfo;
	import org.osmf.utils.OSMFStrings;

	public class KalturaMixPluginInfo extends PluginInfo
	{
		private var kalturaMixLoader:KalturaMixLoader = new KalturaMixLoader();
		private var mediaInfoObjects:Vector.<MediaFactoryItem>;			
		public var disableUrlHashing : Boolean = false;
		public function KalturaMixPluginInfo(isHashDisabled : Boolean)
		{
			super(null,null);
			mediaInfoObjects = new Vector.<MediaFactoryItem>();
			disableUrlHashing = isHashDisabled;
			var mediaInfo:MediaFactoryItem = new MediaFactoryItem("com.kaltura.osmf.KalturaMixElement", canHandleResource, createKalturaMixElement);
			mediaInfoObjects.push(mediaInfo);

		}

		/**
		 * @inheritDoc
		 */
		override public function get numMediaFactoryItems():int
		{
			return mediaInfoObjects.length;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getMediaFactoryItemAt(index:int):MediaFactoryItem
		{
			if (index >= mediaInfoObjects.length)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));				
			}
			
			return mediaInfoObjects[index];
		}
		
		/**
		 * @inheritDoc
		 */
		override public function isFrameworkVersionSupported(version:String):Boolean
		{
			if ((version == null) || (version.length < 1))
			{
				return false;
			}
			
			var verInfo:Array = version.split(".");
			var major:int = 0
			var minor:int = 0
			var subMinor:int = 0;
			
			if (verInfo.length >= 1)
			{
				major = parseInt(verInfo[0]);
			}
			if (verInfo.length >= 2)
			{
				minor = parseInt(verInfo[1]);
			}
			if (verInfo.length >= 3)
			{
				subMinor = parseInt(verInfo[2]);
			}
			
			// Framework version 0.8.0 is the minimum this plugin supports.
			return ((major > 0) || ((major == 0) && (minor >= 8) && (subMinor >= 0)));
		}
		
		private function createKalturaMixElement():MediaElement
		{
			var newElement :KalturaMixElement = new KalturaMixElement(kalturaMixLoader);
			newElement.disableUrlHashing = disableUrlHashing;
			return newElement;
		}
		
		/**
		 * checks whether the plugin can handle a resource  
		 * @param resource	resource to check
		 * @return true if the plugin can handle the given resource 
		 */		
		public function canHandleResource(resource:MediaResourceBase):Boolean
		{
			//if (resource is KalturaEntryResource && (resource as KalturaEntryResource).entry is KalturaEntry)
			//	return true;
			if (resource is KalturaBaseEntryResource && (resource as KalturaBaseEntryResource).entry is KalturaMixEntry)
				return true;
				
			return false;
		}
		
	}
}