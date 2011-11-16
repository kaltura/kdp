package com.kaltura.delegates.adminUser
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class AdminUserSetInitialPasswordDelegate extends WebDelegateBase
	{
		public function AdminUserSetInitialPasswordDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
