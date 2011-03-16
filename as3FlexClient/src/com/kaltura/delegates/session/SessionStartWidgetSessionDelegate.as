package com.kaltura.delegates.session
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class SessionStartWidgetSessionDelegate extends WebDelegateBase
	{
		public function SessionStartWidgetSessionDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
