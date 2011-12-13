package com.kaltura.delegates.entryDistribution
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class EntryDistributionServeSentDataDelegate extends WebDelegateBase
	{
		public function EntryDistributionServeSentDataDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

		override protected function sendRequest():void {
			call.handleResult(getServeUrl(_call));
		}

	}
}
