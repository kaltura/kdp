package com.kaltura.delegates.metadataBatch
{
	import flash.utils.getDefinitionByName;
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	public class MetadataBatchUpdateExclusiveConvertProfileJobDelegate extends WebDelegateBase
	{
		public function MetadataBatchUpdateExclusiveConvertProfileJobDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
