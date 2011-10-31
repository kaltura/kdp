package com.kaltura.delegates.captionAssetItem
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class CaptionAssetItemSearchDelegate extends WebDelegateBase
	{
		public function CaptionAssetItemSearchDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
