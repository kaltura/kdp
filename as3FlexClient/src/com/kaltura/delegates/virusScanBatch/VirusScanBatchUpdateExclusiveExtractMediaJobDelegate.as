package com.kaltura.delegates.virusScanBatch
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class VirusScanBatchUpdateExclusiveExtractMediaJobDelegate extends WebDelegateBase
	{
		public function VirusScanBatchUpdateExclusiveExtractMediaJobDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
