package com.kaltura.delegates.entryAdmin
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class EntryAdminGetByFlavorIdDelegate extends WebDelegateBase
	{
		public function EntryAdminGetByFlavorIdDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
