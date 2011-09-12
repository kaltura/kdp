package com.kaltura.delegates.storageProfile
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class StorageProfileListByPartnerDelegate extends WebDelegateBase
	{
		public function StorageProfileListByPartnerDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
