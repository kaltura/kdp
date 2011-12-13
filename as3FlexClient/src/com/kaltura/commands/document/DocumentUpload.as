package com.kaltura.commands.document
{
	import flash.net.FileReference;
	import com.kaltura.net.KalturaFileCall;
	import com.kaltura.delegates.document.DocumentUploadDelegate;

	public class DocumentUpload extends KalturaFileCall
	{
		public var fileData:Object;

		/**
		 * @param fileData Object - FileReference or ByteArray
		 **/
		public function DocumentUpload( fileData : Object )
		{
			service= 'document';
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
			delegate = new DocumentUploadDelegate( this , config );
		}
	}
}
