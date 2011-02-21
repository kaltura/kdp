package com.kaltura.delegates.systemUser
{
	import flash.utils.getDefinitionByName;
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	public class SystemUserGetByEmailDelegate extends WebDelegateBase
	{
		public function SystemUserGetByEmailDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
