package com.kaltura.delegates.systemPartner
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class SystemPartnerGetUsageDelegate extends WebDelegateBase
	{
		public function SystemPartnerGetUsageDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
