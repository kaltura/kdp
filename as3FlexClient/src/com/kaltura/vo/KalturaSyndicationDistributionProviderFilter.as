package com.kaltura.vo
{
	import com.kaltura.vo.KalturaSyndicationDistributionProviderBaseFilter;

	[Bindable]
	public dynamic class KalturaSyndicationDistributionProviderFilter extends KalturaSyndicationDistributionProviderBaseFilter
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
