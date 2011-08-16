package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFlavorParamsOutputBaseFilter;

	[Bindable]
	public dynamic class KalturaFlavorParamsOutputFilter extends KalturaFlavorParamsOutputBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
