package com.kaltura.delegates.thumbParamsOutput
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class ThumbParamsOutputGetDelegate extends WebDelegateBase
	{
		public function ThumbParamsOutputGetDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
