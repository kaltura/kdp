package com.kaltura.vo
{
	import com.kaltura.vo.KalturaComcastDistributionProfileBaseFilter;

	[Bindable]
	public dynamic class KalturaComcastDistributionProfileFilter extends KalturaComcastDistributionProfileBaseFilter
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
