package com.kaltura.delegates.upload
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class UploadGetUploadedFileTokenByFileNameDelegate extends WebDelegateBase
	{
		public function UploadGetUploadedFileTokenByFileNameDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
