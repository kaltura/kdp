package com.kaltura.delegates.syndicationFeed
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class SyndicationFeedUpdateDelegate extends WebDelegateBase
	{
		public function SyndicationFeedUpdateDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
