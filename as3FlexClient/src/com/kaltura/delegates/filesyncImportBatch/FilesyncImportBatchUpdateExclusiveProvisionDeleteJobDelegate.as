package com.kaltura.delegates.filesyncImportBatch
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class FilesyncImportBatchUpdateExclusiveProvisionDeleteJobDelegate extends WebDelegateBase
	{
		public function FilesyncImportBatchUpdateExclusiveProvisionDeleteJobDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
