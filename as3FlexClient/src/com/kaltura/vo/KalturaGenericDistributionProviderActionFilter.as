package com.kaltura.vo
{
	import com.kaltura.vo.KalturaGenericDistributionProviderActionBaseFilter;

	[Bindable]
	public dynamic class KalturaGenericDistributionProviderActionFilter extends KalturaGenericDistributionProviderActionBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
