package com.kaltura.delegates.auditTrail
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class AuditTrailAddDelegate extends WebDelegateBase
	{
		public function AuditTrailAddDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
