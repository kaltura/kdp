package com.kaltura.delegates.distributionProfile
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class DistributionProfileUpdateDelegate extends WebDelegateBase
	{
		public function DistributionProfileUpdateDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
