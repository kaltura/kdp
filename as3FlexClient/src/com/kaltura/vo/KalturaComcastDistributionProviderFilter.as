package com.kaltura.vo
{
	import com.kaltura.vo.KalturaComcastDistributionProviderBaseFilter;

	[Bindable]
	public dynamic class KalturaComcastDistributionProviderFilter extends KalturaComcastDistributionProviderBaseFilter
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
