package com.kaltura.vo
{
	import com.kaltura.vo.KalturaTVComDistributionProfileBaseFilter;

	[Bindable]
	public dynamic class KalturaTVComDistributionProfileFilter extends KalturaTVComDistributionProfileBaseFilter
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
