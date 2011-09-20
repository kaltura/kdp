package com.kaltura.commands.uploadToken
{
	import com.kaltura.vo.KalturaUploadToken;
	import com.kaltura.delegates.uploadToken.UploadTokenAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class UploadTokenAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param uploadToken KalturaUploadToken
		 **/
		public function UploadTokenAdd( uploadToken : KalturaUploadToken=null )
		{
			if(uploadToken== null)uploadToken= new KalturaUploadToken();
			service= 'uploadtoken';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(uploadToken, 'uploadToken');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new UploadTokenAddDelegate( this , config );
		}
	}
}
