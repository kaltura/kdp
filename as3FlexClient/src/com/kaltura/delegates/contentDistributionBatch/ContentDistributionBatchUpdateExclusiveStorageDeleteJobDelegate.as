package com.kaltura.delegates.contentDistributionBatch
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class ContentDistributionBatchUpdateExclusiveStorageDeleteJobDelegate extends WebDelegateBase
	{
		public function ContentDistributionBatchUpdateExclusiveStorageDeleteJobDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
