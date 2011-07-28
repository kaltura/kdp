package com.kaltura.commands.uploadToken
{
	import com.kaltura.delegates.uploadToken.UploadTokenDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class UploadTokenDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param uploadTokenId String
		 **/
		public function UploadTokenDelete( uploadTokenId : String )
		{
			service= 'uploadtoken';
			action= 'delete';

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
			delegate = new UploadTokenDeleteDelegate( this , config );
		}
	}
}
