package com.kaltura.delegates.contentDistributionBatch
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class ContentDistributionBatchUpdateExclusivePostConvertJobDelegate extends WebDelegateBase
	{
		public function ContentDistributionBatchUpdateExclusivePostConvertJobDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
