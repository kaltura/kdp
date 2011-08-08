package com.kaltura.vo
{
	import com.kaltura.vo.KalturaGenericDistributionProviderBaseFilter;

	[Bindable]
	public dynamic class KalturaGenericDistributionProviderFilter extends KalturaGenericDistributionProviderBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
