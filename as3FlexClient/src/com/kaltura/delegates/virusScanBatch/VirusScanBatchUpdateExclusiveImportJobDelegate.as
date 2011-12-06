package com.kaltura.delegates.virusScanBatch
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class VirusScanBatchUpdateExclusiveImportJobDelegate extends WebDelegateBase
	{
		public function VirusScanBatchUpdateExclusiveImportJobDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
