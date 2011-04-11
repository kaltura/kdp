package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFlavorAssetBaseFilter;

	[Bindable]
	public dynamic class KalturaFlavorAssetFilter extends KalturaFlavorAssetBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
