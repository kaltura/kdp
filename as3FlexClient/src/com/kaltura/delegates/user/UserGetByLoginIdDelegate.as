package com.kaltura.delegates.user
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class UserGetByLoginIdDelegate extends WebDelegateBase
	{
		public function UserGetByLoginIdDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
