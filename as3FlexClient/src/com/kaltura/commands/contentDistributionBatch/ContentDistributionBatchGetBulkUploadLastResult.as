package com.kaltura.commands.contentDistributionBatch
{
	import com.kaltura.delegates.contentDistributionBatch.ContentDistributionBatchGetBulkUploadLastResultDelegate;
	import com.kaltura.net.KalturaCall;

	public class ContentDistributionBatchGetBulkUploadLastResult extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param bulkUploadJobId int
		 **/
		public function ContentDistributionBatchGetBulkUploadLastResult( bulkUploadJobId : int )
		{
			service= 'contentdistribution_contentdistributionbatch';
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
			delegate = new ContentDistributionBatchGetBulkUploadLastResultDelegate( this , config );
		}
	}
}
