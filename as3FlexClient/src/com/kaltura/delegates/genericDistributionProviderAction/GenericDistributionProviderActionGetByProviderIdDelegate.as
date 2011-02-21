package com.kaltura.delegates.genericDistributionProviderAction
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class GenericDistributionProviderActionGetByProviderIdDelegate extends WebDelegateBase
	{
		public function GenericDistributionProviderActionGetByProviderIdDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
