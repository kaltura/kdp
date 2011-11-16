package com.kaltura.osmf.kalturaMix
{
	import flash.system.LoaderContext;
	
	import org.osmf.media.MediaResourceBase;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoaderBase;

	public class KalturaMixLoadTrait extends LoadTrait
	{
		public function KalturaMixLoadTrait(loader:LoaderBase, resource:MediaResourceBase)
		{
			super(loader, resource);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function loadStateChangeStart(newState:String):void
		{
			if (newState == LoadState.READY)
			{
			}
			else if (newState == LoadState.UNINITIALIZED)
			{
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get bytesLoaded():Number
		{
			return 1;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get bytesTotal():Number
		{
			return 1;
		}
		
		// Internals
		//
/*		
		private function onNetStatus(event:NetStatusEvent):void
		{
			if (netStream.bytesTotal > 0)
			{
				dispatchEvent
					( new LoadEvent
						( LoadEvent.BYTES_TOTAL_CHANGE
						, false
						, false
						, null
						, netStream.bytesTotal
						)
					);
					
				netStream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			}
		}
*/
	}
}