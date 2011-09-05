package com.kaltura.vo
{
	import com.kaltura.vo.KalturaComcastMrssDistributionProviderBaseFilter;

	[Bindable]
	public dynamic class KalturaComcastMrssDistributionProviderFilter extends KalturaComcastMrssDistributionProviderBaseFilter
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
