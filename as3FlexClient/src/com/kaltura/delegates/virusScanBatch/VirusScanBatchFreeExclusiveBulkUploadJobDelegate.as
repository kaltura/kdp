package com.kaltura.delegates.virusScanBatch
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class VirusScanBatchFreeExclusiveBulkUploadJobDelegate extends WebDelegateBase
	{
		public function VirusScanBatchFreeExclusiveBulkUploadJobDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
