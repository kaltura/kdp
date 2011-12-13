package com.kaltura.delegates.metadata
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class MetadataServeDelegate extends WebDelegateBase
	{
		public function MetadataServeDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

		override protected function sendRequest():void {
			call.handleResult(getServeUrl(_call));
		}

	}
}
