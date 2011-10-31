package com.kaltura.vo
{
	import com.kaltura.vo.KalturaComcastMrssDistributionProfileBaseFilter;

	[Bindable]
	public dynamic class KalturaComcastMrssDistributionProfileFilter extends KalturaComcastMrssDistributionProfileBaseFilter
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
