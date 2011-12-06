package com.kaltura.delegates.flavorAsset
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class FlavorAssetSetContentDelegate extends WebDelegateBase
	{
		public function FlavorAssetSetContentDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
