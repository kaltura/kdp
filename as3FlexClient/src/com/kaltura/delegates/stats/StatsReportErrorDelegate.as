package com.kaltura.delegates.stats
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class StatsReportErrorDelegate extends WebDelegateBase
	{
		public function StatsReportErrorDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
