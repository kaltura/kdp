package com.kaltura.delegates.kalturaInternalToolsSystemHelper
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class KalturaInternalToolsSystemHelperGetRemoteAddressDelegate extends WebDelegateBase
	{
		public function KalturaInternalToolsSystemHelperGetRemoteAddressDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

		override public function parse(result:XML) : *
		{
			return result.result.toString();
		}

	}
}
