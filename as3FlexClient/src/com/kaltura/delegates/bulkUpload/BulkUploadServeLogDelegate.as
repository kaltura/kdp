package com.kaltura.delegates.bulkUpload
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class BulkUploadServeLogDelegate extends WebDelegateBase
	{
		public function BulkUploadServeLogDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

		override protected function sendRequest():void {
			call.handleResult(getServeUrl(_call));
		}

	}
}
