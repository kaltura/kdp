package com.kaltura.delegates.filesyncImportBatch
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class FilesyncImportBatchLogConversionDelegate extends WebDelegateBase
	{
		public function FilesyncImportBatchLogConversionDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
