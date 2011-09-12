package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDwhHourlyPartnerBaseFilter;

	[Bindable]
	public dynamic class KalturaDwhHourlyPartnerFilter extends KalturaDwhHourlyPartnerBaseFilter
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
