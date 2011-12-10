package com.kaltura.delegates.thumbAsset
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class ThumbAssetSetContentDelegate extends WebDelegateBase
	{
		public function ThumbAssetSetContentDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
