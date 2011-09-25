package com.kaltura.commands.virusScanBatch
{
	import com.kaltura.delegates.virusScanBatch.VirusScanBatchUpdateBulkUploadResultsDelegate;
	import com.kaltura.net.KalturaCall;

	public class VirusScanBatchUpdateBulkUploadResults extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param bulkUploadJobId int
		 **/
		public function VirusScanBatchUpdateBulkUploadResults( bulkUploadJobId : int )
		{
			service= 'virusscan_virusscanbatch';
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
			delegate = new VirusScanBatchUpdateBulkUploadResultsDelegate( this , config );
		}
	}
}
