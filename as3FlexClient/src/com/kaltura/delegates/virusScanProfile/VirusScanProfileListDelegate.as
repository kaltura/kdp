package com.kaltura.delegates.virusScanProfile
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class VirusScanProfileListDelegate extends WebDelegateBase
	{
		public function VirusScanProfileListDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
