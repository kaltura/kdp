package com.kaltura.delegates.filesyncImportBatch
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class FilesyncImportBatchGetExclusiveNotificationJobsDelegate extends WebDelegateBase
	{
		public function FilesyncImportBatchGetExclusiveNotificationJobsDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
