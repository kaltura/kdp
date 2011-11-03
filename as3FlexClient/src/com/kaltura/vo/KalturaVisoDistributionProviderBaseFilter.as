package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDistributionProviderFilter;

	[Bindable]
	public dynamic class KalturaVisoDistributionProviderBaseFilter extends KalturaDistributionProviderFilter
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
