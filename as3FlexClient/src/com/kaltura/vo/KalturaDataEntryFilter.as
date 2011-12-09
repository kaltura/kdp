package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDataEntryBaseFilter;

	[Bindable]
	public dynamic class KalturaDataEntryFilter extends KalturaDataEntryBaseFilter
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
