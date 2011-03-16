package com.kaltura.vo
{
	import com.kaltura.vo.KalturaLiveStreamEntryFilter;

	[Bindable]
	public dynamic class KalturaLiveStreamAdminEntryBaseFilter extends KalturaLiveStreamEntryFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
