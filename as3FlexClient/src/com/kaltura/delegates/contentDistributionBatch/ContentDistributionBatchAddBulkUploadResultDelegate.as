package com.kaltura.delegates.contentDistributionBatch
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class ContentDistributionBatchAddBulkUploadResultDelegate extends WebDelegateBase
	{
		public function ContentDistributionBatchAddBulkUploadResultDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
