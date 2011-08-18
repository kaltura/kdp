package com.kaltura.delegates.user
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class UserSetInitialPasswordDelegate extends WebDelegateBase
	{
		public function UserSetInitialPasswordDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
