package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAssetFilter;

	[Bindable]
	public dynamic class KalturaFlavorAssetBaseFilter extends KalturaAssetFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
