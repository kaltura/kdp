package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFreewheelGenericDistributionProviderBaseFilter;

	[Bindable]
	public dynamic class KalturaFreewheelGenericDistributionProviderFilter extends KalturaFreewheelGenericDistributionProviderBaseFilter
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
