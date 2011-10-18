package com.kaltura.delegates.flavorParamsOutput
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class FlavorParamsOutputListDelegate extends WebDelegateBase
	{
		public function FlavorParamsOutputListDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
