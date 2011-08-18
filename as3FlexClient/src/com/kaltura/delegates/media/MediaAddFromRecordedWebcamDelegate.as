package com.kaltura.delegates.media
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class MediaAddFromRecordedWebcamDelegate extends WebDelegateBase
	{
		public function MediaAddFromRecordedWebcamDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
