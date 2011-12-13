package com.kaltura.delegates.conversionProfile
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class ConversionProfileSetAsDefaultDelegate extends WebDelegateBase
	{
		public function ConversionProfileSetAsDefaultDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
