package com.kaltura.delegates.metadataProfile
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class MetadataProfileServeDelegate extends WebDelegateBase
	{
		public function MetadataProfileServeDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

		override protected function sendRequest():void {
			call.handleResult(getServeUrl(_call));
		}

	}
}
