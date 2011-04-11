package com.kaltura.delegates.annotation
{
	import flash.utils.getDefinitionByName;

	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;

	public class AnnotationDeleteDelegate extends WebDelegateBase
	{
		public function AnnotationDeleteDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
