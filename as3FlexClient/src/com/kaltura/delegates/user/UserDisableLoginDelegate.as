package com.kaltura.delegates.user
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class UserDisableLoginDelegate extends WebDelegateBase
	{
		public function UserDisableLoginDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
