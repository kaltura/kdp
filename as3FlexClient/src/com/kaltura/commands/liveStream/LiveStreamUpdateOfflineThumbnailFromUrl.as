package com.kaltura.commands.liveStream
{
	import com.kaltura.delegates.liveStream.LiveStreamUpdateOfflineThumbnailFromUrlDelegate;
	import com.kaltura.net.KalturaCall;

	public class LiveStreamUpdateOfflineThumbnailFromUrl extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param url String
		 **/
		public function LiveStreamUpdateOfflineThumbnailFromUrl( entryId : String,url : String )
		{
			service= 'livestream';
			action= 'updateOfflineThumbnailFromUrl';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			keyArr.push('url');
			valueArr.push(url);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new LiveStreamUpdateOfflineThumbnailFromUrlDelegate( this , config );
		}
	}
}
