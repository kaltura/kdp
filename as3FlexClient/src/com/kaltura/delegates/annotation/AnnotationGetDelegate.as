package com.kaltura.delegates.annotation
{
	import flash.utils.getDefinitionByName;

	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;

	public class AnnotationGetDelegate extends WebDelegateBase
	{
		public function AnnotationGetDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
