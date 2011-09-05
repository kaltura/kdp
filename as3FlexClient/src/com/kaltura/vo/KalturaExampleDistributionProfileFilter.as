package com.kaltura.vo
{
	import com.kaltura.vo.KalturaExampleDistributionProfileBaseFilter;

	[Bindable]
	public dynamic class KalturaExampleDistributionProfileFilter extends KalturaExampleDistributionProfileBaseFilter
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
