package com.kaltura.commands.filesyncImportBatch
{
	import com.kaltura.delegates.filesyncImportBatch.FilesyncImportBatchUpdateBulkUploadResultsDelegate;
	import com.kaltura.net.KalturaCall;

	public class FilesyncImportBatchUpdateBulkUploadResults extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param bulkUploadJobId int
		 **/
		public function FilesyncImportBatchUpdateBulkUploadResults( bulkUploadJobId : int )
		{
			service= 'multicenters_filesyncimportbatch';
			action= 'updateBulkUploadResults';

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
			delegate = new FilesyncImportBatchUpdateBulkUploadResultsDelegate( this , config );
		}
	}
}
