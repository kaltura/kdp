package com.kaltura.delegates.notification
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class NotificationGetClientNotificationDelegate extends WebDelegateBase
	{
		public function NotificationGetClientNotificationDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
