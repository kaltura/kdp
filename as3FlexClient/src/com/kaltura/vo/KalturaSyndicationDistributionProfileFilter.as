package com.kaltura.vo
{
	import com.kaltura.vo.KalturaSyndicationDistributionProfileBaseFilter;

	[Bindable]
	public dynamic class KalturaSyndicationDistributionProfileFilter extends KalturaSyndicationDistributionProfileBaseFilter
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
