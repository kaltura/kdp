package com.kaltura.delegates.genericDistributionProviderAction
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class GenericDistributionProviderActionAddDelegate extends WebDelegateBase
	{
		public function GenericDistributionProviderActionAddDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
