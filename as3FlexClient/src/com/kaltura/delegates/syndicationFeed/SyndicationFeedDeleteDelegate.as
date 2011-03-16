package com.kaltura.delegates.syndicationFeed
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class SyndicationFeedDeleteDelegate extends WebDelegateBase
	{
		public function SyndicationFeedDeleteDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
