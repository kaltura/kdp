package com.kaltura.vo
{
	import com.kaltura.vo.KalturaConfigurableDistributionProfileBaseFilter;

	[Bindable]
	public dynamic class KalturaConfigurableDistributionProfileFilter extends KalturaConfigurableDistributionProfileBaseFilter
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
