package com.kaltura.delegates.mixing
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class MixingAnonymousRankDelegate extends WebDelegateBase
	{
		public function MixingAnonymousRankDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
