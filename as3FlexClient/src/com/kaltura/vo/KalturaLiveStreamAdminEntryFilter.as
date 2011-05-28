package com.kaltura.vo
{
	import com.kaltura.vo.KalturaLiveStreamAdminEntryBaseFilter;

	[Bindable]
	public dynamic class KalturaLiveStreamAdminEntryFilter extends KalturaLiveStreamAdminEntryBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
