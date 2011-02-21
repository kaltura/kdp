package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAssetParamsOutputBaseFilter;

	[Bindable]
	public dynamic class KalturaAssetParamsOutputFilter extends KalturaAssetParamsOutputBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
