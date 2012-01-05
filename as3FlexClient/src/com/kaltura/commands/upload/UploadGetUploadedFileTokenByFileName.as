package com.kaltura.commands.upload
{
	import com.kaltura.delegates.upload.UploadGetUploadedFileTokenByFileNameDelegate;
	import com.kaltura.net.KalturaCall;

	public class UploadGetUploadedFileTokenByFileName extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param fileName String
		 **/
		public function UploadGetUploadedFileTokenByFileName( fileName : String )
		{
			service= 'upload';
			action= 'getUploadedFileTokenByFileName';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('fileName');
			valueArr.push(fileName);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new UploadGetUploadedFileTokenByFileNameDelegate( this , config );
		}
	}
}
