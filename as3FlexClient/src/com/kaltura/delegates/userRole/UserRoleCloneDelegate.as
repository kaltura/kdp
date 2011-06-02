package com.kaltura.delegates.userRole
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class UserRoleCloneDelegate extends WebDelegateBase
	{
		public function UserRoleCloneDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
