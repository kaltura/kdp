package com.kaltura.vo
{
	import com.kaltura.vo.KalturaHuluDistributionProviderBaseFilter;

	[Bindable]
	public dynamic class KalturaHuluDistributionProviderFilter extends KalturaHuluDistributionProviderBaseFilter
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
