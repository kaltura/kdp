package com.kaltura.commands.uploadToken
{
	import com.kaltura.delegates.uploadToken.UploadTokenGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class UploadTokenGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param uploadTokenId String
		 **/
		public function UploadTokenGet( uploadTokenId : String )
		{
			service= 'uploadtoken';
			action= 'get';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('uploadTokenId');
			valueArr.push(uploadTokenId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new UploadTokenGetDelegate( this , config );
		}
	}
}
