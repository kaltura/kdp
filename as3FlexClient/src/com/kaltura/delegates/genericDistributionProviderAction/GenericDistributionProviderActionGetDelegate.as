package com.kaltura.delegates.genericDistributionProviderAction
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class GenericDistributionProviderActionGetDelegate extends WebDelegateBase
	{
		public function GenericDistributionProviderActionGetDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
