package com.kaltura.vo
{
	import com.kaltura.vo.KalturaCuePointBaseFilter;

	[Bindable]
	public dynamic class KalturaCuePointFilter extends KalturaCuePointBaseFilter
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
