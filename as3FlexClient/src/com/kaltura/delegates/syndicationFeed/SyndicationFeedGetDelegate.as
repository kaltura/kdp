package com.kaltura.delegates.syndicationFeed
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class SyndicationFeedGetDelegate extends WebDelegateBase
	{
		public function SyndicationFeedGetDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
