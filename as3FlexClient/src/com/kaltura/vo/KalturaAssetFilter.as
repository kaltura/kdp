package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAssetBaseFilter;

	[Bindable]
	public dynamic class KalturaAssetFilter extends KalturaAssetBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
