package com.kaltura.vo
{
	import com.kaltura.vo.KalturaMediaEntryFilter;

	[Bindable]
	public dynamic class KalturaLiveStreamEntryBaseFilter extends KalturaMediaEntryFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

	}
}
