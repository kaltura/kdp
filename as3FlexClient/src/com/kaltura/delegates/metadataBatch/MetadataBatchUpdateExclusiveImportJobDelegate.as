package com.kaltura.delegates.metadataBatch
{
	import flash.utils.getDefinitionByName;
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	public class MetadataBatchUpdateExclusiveImportJobDelegate extends WebDelegateBase
	{
		public function MetadataBatchUpdateExclusiveImportJobDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
