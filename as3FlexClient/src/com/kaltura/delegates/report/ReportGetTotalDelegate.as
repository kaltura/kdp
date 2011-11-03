package com.kaltura.delegates.report
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class ReportGetTotalDelegate extends WebDelegateBase
	{
		public function ReportGetTotalDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
