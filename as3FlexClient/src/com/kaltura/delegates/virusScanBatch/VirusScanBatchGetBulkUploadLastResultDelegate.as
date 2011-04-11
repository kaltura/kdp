package com.kaltura.delegates.virusScanBatch
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class VirusScanBatchGetBulkUploadLastResultDelegate extends WebDelegateBase
	{
		public function VirusScanBatchGetBulkUploadLastResultDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
