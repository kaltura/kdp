package com.kaltura.delegates.filesyncImportBatch
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class FilesyncImportBatchResetJobExecutionAttemptsDelegate extends WebDelegateBase
	{
		public function FilesyncImportBatchResetJobExecutionAttemptsDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
