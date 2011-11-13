package com.kaltura.commands.liveStream
{
	import flash.net.FileReference;
	import com.kaltura.net.KalturaFileCall;
	import com.kaltura.delegates.liveStream.LiveStreamUpdateOfflineThumbnailJpegDelegate;

	public class LiveStreamUpdateOfflineThumbnailJpeg extends KalturaFileCall
	{
		public var fileData:Object;

		/**
		 * @param entryId String
		 * @param fileData Object - FileReference or ByteArray
		 **/
		public function LiveStreamUpdateOfflineThumbnailJpeg( entryId : String,fileData : Object )
		{
			service= 'livestream';
			action= 'updateOfflineThumbnailJpeg';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			this.fileData = fileData;
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new LiveStreamUpdateOfflineThumbnailJpegDelegate( this , config );
		}
	}
}
