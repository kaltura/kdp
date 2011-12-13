package com.kaltura.delegates.EmailIngestionProfile
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class EmailIngestionProfileGetByEmailAddressDelegate extends WebDelegateBase
	{
		public function EmailIngestionProfileGetByEmailAddressDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
