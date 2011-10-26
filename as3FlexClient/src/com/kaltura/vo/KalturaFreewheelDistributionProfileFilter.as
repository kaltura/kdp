package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFreewheelDistributionProfileBaseFilter;

	[Bindable]
	public dynamic class KalturaFreewheelDistributionProfileFilter extends KalturaFreewheelDistributionProfileBaseFilter
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
