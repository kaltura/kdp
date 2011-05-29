package com.kaltura.delegates.contentDistributionBatch
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class ContentDistributionBatchUpdateSunStatusDelegate extends WebDelegateBase
	{
		public function ContentDistributionBatchUpdateSunStatusDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
