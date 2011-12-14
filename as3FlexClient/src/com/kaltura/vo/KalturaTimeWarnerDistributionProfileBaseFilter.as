package com.kaltura.vo
{
	import com.kaltura.vo.KalturaConfigurableDistributionProfileFilter;

	[Bindable]
	public dynamic class KalturaTimeWarnerDistributionProfileBaseFilter extends KalturaConfigurableDistributionProfileFilter
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
