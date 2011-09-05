package com.kaltura.delegates.media
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class MediaApproveReplaceDelegate extends WebDelegateBase
	{
		public function MediaApproveReplaceDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
