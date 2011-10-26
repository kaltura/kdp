package com.kaltura.commands.filesyncImportBatch
{
	import com.kaltura.delegates.filesyncImportBatch.FilesyncImportBatchGetBulkUploadLastResultDelegate;
	import com.kaltura.net.KalturaCall;

	public class FilesyncImportBatchGetBulkUploadLastResult extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param bulkUploadJobId int
		 **/
		public function FilesyncImportBatchGetBulkUploadLastResult( bulkUploadJobId : int )
		{
			service= 'multicenters_filesyncimportbatch';
			action= 'getBulkUploadLastResult';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('bulkUploadJobId');
			valueArr.push(bulkUploadJobId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new FilesyncImportBatchGetBulkUploadLastResultDelegate( this , config );
		}
	}
}
