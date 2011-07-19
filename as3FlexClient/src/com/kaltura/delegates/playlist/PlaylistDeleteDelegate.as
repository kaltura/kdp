package com.kaltura.delegates.playlist
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class PlaylistDeleteDelegate extends WebDelegateBase
	{
		public function PlaylistDeleteDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
