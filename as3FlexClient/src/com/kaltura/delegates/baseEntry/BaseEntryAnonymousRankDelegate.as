package com.kaltura.delegates.baseEntry
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class BaseEntryAnonymousRankDelegate extends WebDelegateBase
	{
		public function BaseEntryAnonymousRankDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
