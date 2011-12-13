package com.kaltura.commands.baseEntry
{
	import flash.net.FileReference;
	import com.kaltura.net.KalturaFileCall;
	import com.kaltura.delegates.baseEntry.BaseEntryUpdateThumbnailJpegDelegate;

	public class BaseEntryUpdateThumbnailJpeg extends KalturaFileCall
	{
		public var fileData:Object;

		/**
		 * @param entryId String
		 * @param fileData Object - FileReference or ByteArray
		 **/
		public function BaseEntryUpdateThumbnailJpeg( entryId : String,fileData : Object )
		{
			service= 'baseentry';
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
			delegate = new BaseEntryUpdateThumbnailJpegDelegate( this , config );
		}
	}
}
