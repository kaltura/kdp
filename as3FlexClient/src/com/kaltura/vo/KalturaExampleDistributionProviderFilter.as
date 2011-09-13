package com.kaltura.vo
{
	import com.kaltura.vo.KalturaExampleDistributionProviderBaseFilter;

	[Bindable]
	public dynamic class KalturaExampleDistributionProviderFilter extends KalturaExampleDistributionProviderBaseFilter
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
