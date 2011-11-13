package com.kaltura.vo
{
	import com.kaltura.vo.KalturaTimeWarnerDistributionProviderBaseFilter;

	[Bindable]
	public dynamic class KalturaTimeWarnerDistributionProviderFilter extends KalturaTimeWarnerDistributionProviderBaseFilter
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
