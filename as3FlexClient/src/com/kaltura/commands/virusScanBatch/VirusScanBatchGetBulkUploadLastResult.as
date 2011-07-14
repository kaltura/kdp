package com.kaltura.commands.virusScanBatch
{
	import com.kaltura.delegates.virusScanBatch.VirusScanBatchGetBulkUploadLastResultDelegate;
	import com.kaltura.net.KalturaCall;

	public class VirusScanBatchGetBulkUploadLastResult extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param bulkUploadJobId int
		 **/
		public function VirusScanBatchGetBulkUploadLastResult( bulkUploadJobId : int )
		{
			service= 'virusscan_virusscanbatch';
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
			delegate = new VirusScanBatchGetBulkUploadLastResultDelegate( this , config );
		}
	}
}
