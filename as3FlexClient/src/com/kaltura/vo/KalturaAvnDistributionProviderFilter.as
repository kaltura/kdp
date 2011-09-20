package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAvnDistributionProviderBaseFilter;

	[Bindable]
	public dynamic class KalturaAvnDistributionProviderFilter extends KalturaAvnDistributionProviderBaseFilter
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
