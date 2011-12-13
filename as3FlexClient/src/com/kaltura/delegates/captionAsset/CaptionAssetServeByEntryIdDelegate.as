package com.kaltura.delegates.captionAsset
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class CaptionAssetServeByEntryIdDelegate extends WebDelegateBase
	{
		public function CaptionAssetServeByEntryIdDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

		override protected function sendRequest():void {
			call.handleResult(getServeUrl(_call));
		}

	}
}
