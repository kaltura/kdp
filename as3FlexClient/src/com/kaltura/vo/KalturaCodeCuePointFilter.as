package com.kaltura.vo
{
	import com.kaltura.vo.KalturaCodeCuePointBaseFilter;

	[Bindable]
	public dynamic class KalturaCodeCuePointFilter extends KalturaCodeCuePointBaseFilter
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
