package com.kaltura.delegates.report
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class ReportGetTableDelegate extends WebDelegateBase
	{
		public function ReportGetTableDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
