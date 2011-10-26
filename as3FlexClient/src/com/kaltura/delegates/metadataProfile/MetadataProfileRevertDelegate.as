package com.kaltura.delegates.metadataProfile
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class MetadataProfileRevertDelegate extends WebDelegateBase
	{
		public function MetadataProfileRevertDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
