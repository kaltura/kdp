package com.kaltura.delegates.uiConfAdmin
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class UiConfAdminGetDelegate extends WebDelegateBase
	{
		public function UiConfAdminGetDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
