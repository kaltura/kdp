package com.kaltura.commands.media
{
	import flash.net.FileReference;
	import com.kaltura.net.KalturaFileCall;
	import com.kaltura.delegates.media.MediaUpdateThumbnailJpegDelegate;

	public class MediaUpdateThumbnailJpeg extends KalturaFileCall
	{
		public var fileData:Object;

		/**
		 * @param entryId String
		 * @param fileData Object - FileReference or ByteArray
		 **/
		public function MediaUpdateThumbnailJpeg( entryId : String,fileData : Object )
		{
			service= 'media';
			action= 'updateThumbnailJpeg';

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
			delegate = new MediaUpdateThumbnailJpegDelegate( this , config );
		}
	}
}
