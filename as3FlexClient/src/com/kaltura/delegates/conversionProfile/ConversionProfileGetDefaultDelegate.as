package com.kaltura.delegates.conversionProfile
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class ConversionProfileGetDefaultDelegate extends WebDelegateBase
	{
		public function ConversionProfileGetDefaultDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
