package com.kaltura.delegates.dropFolderFile
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class DropFolderFileUpdateStatusDelegate extends WebDelegateBase
	{
		public function DropFolderFileUpdateStatusDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
