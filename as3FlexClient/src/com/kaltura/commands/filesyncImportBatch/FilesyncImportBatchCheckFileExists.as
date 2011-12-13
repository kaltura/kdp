package com.kaltura.commands.filesyncImportBatch
{
	import com.kaltura.delegates.filesyncImportBatch.FilesyncImportBatchCheckFileExistsDelegate;
	import com.kaltura.net.KalturaCall;

	public class FilesyncImportBatchCheckFileExists extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param localPath String
		 * @param size int
		 **/
		public function FilesyncImportBatchCheckFileExists( localPath : String,size : int )
		{
			service= 'multicenters_filesyncimportbatch';
			action= 'checkFileExists';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('localPath');
			valueArr.push(localPath);
			keyArr.push('size');
			valueArr.push(size);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new FilesyncImportBatchCheckFileExistsDelegate( this , config );
		}
	}
}
