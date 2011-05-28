package com.kaltura.vo
{
	import com.kaltura.vo.KalturaMediaFlavorParamsOutputBaseFilter;

	[Bindable]
	public dynamic class KalturaMediaFlavorParamsOutputFilter extends KalturaMediaFlavorParamsOutputBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
