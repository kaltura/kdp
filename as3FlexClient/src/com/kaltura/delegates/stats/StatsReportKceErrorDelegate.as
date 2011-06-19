package com.kaltura.delegates.stats
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class StatsReportKceErrorDelegate extends WebDelegateBase
	{
		public function StatsReportKceErrorDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
