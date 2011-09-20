package com.kaltura.commands.upload
{
	import flash.net.FileReference;
	import com.kaltura.net.KalturaFileCall;
	import com.kaltura.delegates.upload.UploadUploadDelegate;

	public class UploadUpload extends KalturaFileCall
	{
		public var fileData:Object;

		/**
		 * @param fileData Object - FileReference or ByteArray
		 **/
		public function UploadUpload( fileData : Object )
		{
			service= 'upload';
			action= 'upload';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			this.fileData = fileData;
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new UploadUploadDelegate( this , config );
		}
	}
}
