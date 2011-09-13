package com.kaltura.delegates.partner
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class PartnerGetInfoDelegate extends WebDelegateBase
	{
		public function PartnerGetInfoDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
