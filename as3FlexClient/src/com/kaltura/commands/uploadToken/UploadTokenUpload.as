package com.kaltura.commands.uploadToken
{
	import com.kaltura.vo.File;
	import com.kaltura.delegates.uploadToken.UploadTokenUploadDelegate;
	import com.kaltura.net.KalturaCall;

	public class UploadTokenUpload extends KalturaCall
	{
		public var filterFields : String;
		public function UploadTokenUpload( uploadTokenId : String,fileData : file,resume : Boolean=false,finalChunk : Boolean=true )
		{
			service= 'uploadtoken';
			action= 'upload';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'uploadTokenId' );
			valueArr.push( uploadTokenId );
 			keyValArr = kalturaObject2Arrays(fileData,'fileData');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			keyArr.push( 'resume' );
			valueArr.push( resume );
			keyArr.push( 'finalChunk' );
			valueArr.push( finalChunk );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new UploadTokenUploadDelegate( this , config );
		}
	}
}
