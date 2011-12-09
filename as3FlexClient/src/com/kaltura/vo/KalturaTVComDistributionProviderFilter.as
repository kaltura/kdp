package com.kaltura.vo
{
	import com.kaltura.vo.KalturaTVComDistributionProviderBaseFilter;

	[Bindable]
	public dynamic class KalturaTVComDistributionProviderFilter extends KalturaTVComDistributionProviderBaseFilter
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
