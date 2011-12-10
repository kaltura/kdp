package com.kaltura.vo
{
	import com.kaltura.vo.KalturaHuluDistributionProfileBaseFilter;

	[Bindable]
	public dynamic class KalturaHuluDistributionProfileFilter extends KalturaHuluDistributionProfileBaseFilter
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
