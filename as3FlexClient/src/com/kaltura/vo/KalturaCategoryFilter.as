package com.kaltura.vo
{
	import com.kaltura.vo.KalturaCategoryBaseFilter;

	[Bindable]
	public dynamic class KalturaCategoryFilter extends KalturaCategoryBaseFilter
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
