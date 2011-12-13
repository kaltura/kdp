package com.kaltura.delegates.metadata
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class MetadataAddFromBulkDelegate extends WebDelegateBase
	{
		public function MetadataAddFromBulkDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
