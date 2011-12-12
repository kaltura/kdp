package com.kaltura.vo
{
	import com.kaltura.vo.KalturaIdeticDistributionProviderBaseFilter;

	[Bindable]
	public dynamic class KalturaIdeticDistributionProviderFilter extends KalturaIdeticDistributionProviderBaseFilter
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
