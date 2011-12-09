package com.kaltura.delegates.stats
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class StatsKmcCollectDelegate extends WebDelegateBase
	{
		public function StatsKmcCollectDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
