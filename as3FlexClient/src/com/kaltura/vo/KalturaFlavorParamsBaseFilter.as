package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAssetParamsFilter;

	[Bindable]
	public dynamic class KalturaFlavorParamsBaseFilter extends KalturaAssetParamsFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
