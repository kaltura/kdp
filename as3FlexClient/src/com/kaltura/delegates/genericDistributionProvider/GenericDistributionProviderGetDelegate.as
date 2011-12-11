package com.kaltura.delegates.genericDistributionProvider
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class GenericDistributionProviderGetDelegate extends WebDelegateBase
	{
		public function GenericDistributionProviderGetDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
