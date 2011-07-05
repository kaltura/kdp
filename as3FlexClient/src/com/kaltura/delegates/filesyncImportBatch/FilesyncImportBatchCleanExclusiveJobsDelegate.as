package com.kaltura.delegates.filesyncImportBatch
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class FilesyncImportBatchCleanExclusiveJobsDelegate extends WebDelegateBase
	{
		public function FilesyncImportBatchCleanExclusiveJobsDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

		override public function parse(result:XML) : *
		{
			return result.result.toString();
		}

	}
}
