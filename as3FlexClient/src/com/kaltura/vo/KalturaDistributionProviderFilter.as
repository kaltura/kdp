package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDistributionProviderBaseFilter;

	[Bindable]
	public dynamic class KalturaDistributionProviderFilter extends KalturaDistributionProviderBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
