package com.kaltura.delegates.attachmentAsset
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class AttachmentAssetSetContentDelegate extends WebDelegateBase
	{
		public function AttachmentAssetSetContentDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
