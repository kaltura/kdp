package com.kaltura.vo
{
	import com.kaltura.vo.KalturaCaptionParamsBaseFilter;

	[Bindable]
	public dynamic class KalturaCaptionParamsFilter extends KalturaCaptionParamsBaseFilter
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
