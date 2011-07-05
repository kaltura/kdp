package com.kaltura.vo
{
	import com.kaltura.vo.KalturaMediaFlavorParamsBaseFilter;

	[Bindable]
	public dynamic class KalturaMediaFlavorParamsFilter extends KalturaMediaFlavorParamsBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
