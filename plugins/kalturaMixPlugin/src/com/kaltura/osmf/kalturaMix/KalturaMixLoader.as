package com.kaltura.osmf.kalturaMix
{
	import com.kaltura.osmf.kaltura.KalturaBaseEntryResource;
	import com.kaltura.vo.KalturaMixEntry;
	
	import org.osmf.media.MediaResourceBase;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoaderBase;

	public class KalturaMixLoader extends LoaderBase
	{
		public function KalturaMixLoader()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function executeLoad(loadTrait:LoadTrait):void
		{	
			updateLoadTrait(loadTrait, LoadState.LOADING);
			updateLoadTrait(loadTrait, LoadState.READY);		
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function executeUnload(loadTrait:LoadTrait):void
		{
			updateLoadTrait(loadTrait, LoadState.UNLOADING); 			
			updateLoadTrait(loadTrait, LoadState.UNINITIALIZED); 
							
		}
		
		/**
		 * @inheritDoc
		 */
		override public function canHandleResource(resource:MediaResourceBase):Boolean
		{
			//if (resource is KalturaEntryResource && (resource as KalturaEntryResource).entry is KalturaEntry)
			//	return true;
			if (resource is KalturaBaseEntryResource && (resource as KalturaBaseEntryResource).entry is KalturaMixEntry)
				return true;
				
			return false;
		}
		
	}
}