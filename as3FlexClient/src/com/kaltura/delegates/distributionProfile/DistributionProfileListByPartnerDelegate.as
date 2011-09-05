package com.kaltura.delegates.distributionProfile
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class DistributionProfileListByPartnerDelegate extends WebDelegateBase
	{
		public function DistributionProfileListByPartnerDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
