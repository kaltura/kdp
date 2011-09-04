package com.kaltura.delegates.media
{
	import flash.utils.getDefinitionByName;
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	public class MediaAddFromBulkDelegate extends WebDelegateBase
	{
		public function MediaAddFromBulkDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
