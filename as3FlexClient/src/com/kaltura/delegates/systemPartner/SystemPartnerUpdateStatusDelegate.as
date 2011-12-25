package com.kaltura.delegates.systemPartner
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class SystemPartnerUpdateStatusDelegate extends WebDelegateBase
	{
		public function SystemPartnerUpdateStatusDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
