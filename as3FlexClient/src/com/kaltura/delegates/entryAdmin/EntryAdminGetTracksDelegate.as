package com.kaltura.delegates.entryAdmin
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class EntryAdminGetTracksDelegate extends WebDelegateBase
	{
		public function EntryAdminGetTracksDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
