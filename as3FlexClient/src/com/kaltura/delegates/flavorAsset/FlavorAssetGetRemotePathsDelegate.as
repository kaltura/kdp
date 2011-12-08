package com.kaltura.delegates.flavorAsset
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class FlavorAssetGetRemotePathsDelegate extends WebDelegateBase
	{
		public function FlavorAssetGetRemotePathsDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
