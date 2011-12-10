package com.kaltura.delegates.entryDistribution
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class EntryDistributionSubmitUpdateDelegate extends WebDelegateBase
	{
		public function EntryDistributionSubmitUpdateDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
