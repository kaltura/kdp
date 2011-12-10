package com.kaltura.delegates.filesyncImportBatch
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class FilesyncImportBatchUpdateExclusiveStorageExportJobDelegate extends WebDelegateBase
	{
		public function FilesyncImportBatchUpdateExclusiveStorageExportJobDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
