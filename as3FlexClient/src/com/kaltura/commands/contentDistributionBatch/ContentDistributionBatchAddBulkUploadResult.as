package com.kaltura.commands.contentDistributionBatch
{
	import com.kaltura.vo.KalturaBulkUploadResult;
	import com.kaltura.delegates.contentDistributionBatch.ContentDistributionBatchAddBulkUploadResultDelegate;
	import com.kaltura.net.KalturaCall;

	public class ContentDistributionBatchAddBulkUploadResult extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param bulkUploadResult KalturaBulkUploadResult
		 * @param pluginDataArray Array
		 **/
		public function ContentDistributionBatchAddBulkUploadResult( bulkUploadResult : KalturaBulkUploadResult,pluginDataArray : Array=null )
		{
			if(pluginDataArray== null)pluginDataArray= new Array();
			service= 'contentdistribution_contentdistributionbatch';
			action= 'addBulkUploadResult';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(bulkUploadResult, 'bulkUploadResult');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			keyValArr = extractArray(pluginDataArray,'pluginDataArray');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ContentDistributionBatchAddBulkUploadResultDelegate( this , config );
		}
	}
}
