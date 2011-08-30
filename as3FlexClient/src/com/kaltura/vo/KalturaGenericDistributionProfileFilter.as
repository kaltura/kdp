package com.kaltura.vo
{
	import com.kaltura.vo.KalturaGenericDistributionProfileBaseFilter;

	[Bindable]
	public dynamic class KalturaGenericDistributionProfileFilter extends KalturaGenericDistributionProfileBaseFilter
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
