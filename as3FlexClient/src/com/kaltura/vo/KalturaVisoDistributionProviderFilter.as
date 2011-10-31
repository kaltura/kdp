package com.kaltura.vo
{
	import com.kaltura.vo.KalturaVisoDistributionProviderBaseFilter;

	[Bindable]
	public dynamic class KalturaVisoDistributionProviderFilter extends KalturaVisoDistributionProviderBaseFilter
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
