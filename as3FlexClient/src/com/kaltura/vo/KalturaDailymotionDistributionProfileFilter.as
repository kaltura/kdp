package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDailymotionDistributionProfileBaseFilter;

	[Bindable]
	public dynamic class KalturaDailymotionDistributionProfileFilter extends KalturaDailymotionDistributionProfileBaseFilter
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
