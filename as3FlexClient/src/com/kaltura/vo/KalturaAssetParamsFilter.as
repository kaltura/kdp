package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAssetParamsBaseFilter;

	[Bindable]
	public dynamic class KalturaAssetParamsFilter extends KalturaAssetParamsBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
