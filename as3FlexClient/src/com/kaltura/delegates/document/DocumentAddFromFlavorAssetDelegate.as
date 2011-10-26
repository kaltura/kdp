package com.kaltura.delegates.document
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class DocumentAddFromFlavorAssetDelegate extends WebDelegateBase
	{
		public function DocumentAddFromFlavorAssetDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
