package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDistributionProfileFilter;

	[Bindable]
	public dynamic class KalturaFreewheelDistributionProfileBaseFilter extends KalturaDistributionProfileFilter
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
