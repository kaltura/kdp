package com.kaltura.delegates.entryDistribution
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class EntryDistributionRetrySubmitDelegate extends WebDelegateBase
	{
		public function EntryDistributionRetrySubmitDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
