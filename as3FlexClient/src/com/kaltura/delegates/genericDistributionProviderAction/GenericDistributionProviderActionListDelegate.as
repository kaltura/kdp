package com.kaltura.delegates.genericDistributionProviderAction
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class GenericDistributionProviderActionListDelegate extends WebDelegateBase
	{
		public function GenericDistributionProviderActionListDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
