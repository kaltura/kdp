package com.kaltura.delegates.baseEntry
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class BaseEntryGetContextDataDelegate extends WebDelegateBase
	{
		public function BaseEntryGetContextDataDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
