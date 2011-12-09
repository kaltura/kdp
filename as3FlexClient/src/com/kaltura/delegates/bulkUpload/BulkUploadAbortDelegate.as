package com.kaltura.delegates.bulkUpload
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class BulkUploadAbortDelegate extends WebDelegateBase
	{
		public function BulkUploadAbortDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
