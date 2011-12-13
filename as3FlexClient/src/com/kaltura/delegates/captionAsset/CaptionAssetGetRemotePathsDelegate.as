package com.kaltura.delegates.captionAsset
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class CaptionAssetGetRemotePathsDelegate extends WebDelegateBase
	{
		public function CaptionAssetGetRemotePathsDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
