package com.kaltura.delegates.EmailIngestionProfile
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class EmailIngestionProfileDeleteDelegate extends WebDelegateBase
	{
		public function EmailIngestionProfileDeleteDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
