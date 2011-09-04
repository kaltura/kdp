package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDailymotionDistributionProviderBaseFilter;

	[Bindable]
	public dynamic class KalturaDailymotionDistributionProviderFilter extends KalturaDailymotionDistributionProviderBaseFilter
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
