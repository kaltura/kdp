package com.kaltura.delegates.uiConf
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class UiConfCloneDelegate extends WebDelegateBase
	{
		public function UiConfCloneDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
