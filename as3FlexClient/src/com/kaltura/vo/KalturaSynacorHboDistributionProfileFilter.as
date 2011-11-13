package com.kaltura.vo
{
	import com.kaltura.vo.KalturaSynacorHboDistributionProfileBaseFilter;

	[Bindable]
	public dynamic class KalturaSynacorHboDistributionProfileFilter extends KalturaSynacorHboDistributionProfileBaseFilter
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
