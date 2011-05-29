package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDistributionProfileBaseFilter;

	[Bindable]
	public dynamic class KalturaDistributionProfileFilter extends KalturaDistributionProfileBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
