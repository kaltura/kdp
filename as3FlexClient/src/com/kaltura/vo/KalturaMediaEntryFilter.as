package com.kaltura.vo
{
	import com.kaltura.vo.KalturaMediaEntryBaseFilter;

	[Bindable]
	public dynamic class KalturaMediaEntryFilter extends KalturaMediaEntryBaseFilter
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
