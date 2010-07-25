package com.kaltura.commands.upload
{
	import com.kaltura.vo.File;
	import com.kaltura.delegates.upload.UploadUploadDelegate;
	import com.kaltura.net.KalturaCall;

	public class UploadUpload extends KalturaCall
	{
		public var filterFields : String;
		public function UploadUpload( fileData : file )
		{
			service= 'upload';
			action= 'upload';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(fileData,'fileData');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new UploadUploadDelegate( this , config );
		}
	}
}
