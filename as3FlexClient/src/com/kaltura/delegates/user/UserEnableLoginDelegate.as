package com.kaltura.delegates.user
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class UserEnableLoginDelegate extends WebDelegateBase
	{
		public function UserEnableLoginDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
