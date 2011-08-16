package com.kaltura.commands.uploadToken
{
	import flash.net.FileReference;
	import com.kaltura.net.KalturaFileCall;
	import com.kaltura.delegates.uploadToken.UploadTokenUploadDelegate;

	public class UploadTokenUpload extends KalturaFileCall
	{
		public var fileData:Object;

		/**
		 * @param uploadTokenId String
		 * @param fileData Object - FileReference or ByteArray
		 * @param resume Boolean
		 * @param finalChunk Boolean
		 * @param resumeAt int
		 **/
		public function UploadTokenUpload( uploadTokenId : String,fileData : Object,resume : Boolean=false,finalChunk : Boolean=true,resumeAt : int=-1 )
		{
			service= 'uploadtoken';
			action= 'upload';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('uploadTokenId');
			valueArr.push(uploadTokenId);
			this.fileData = fileData;
			keyArr.push('resume');
			valueArr.push(resume);
			keyArr.push('finalChunk');
			valueArr.push(finalChunk);
			keyArr.push('resumeAt');
			valueArr.push(resumeAt);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new UploadTokenUploadDelegate( this , config );
		}
	}
}
