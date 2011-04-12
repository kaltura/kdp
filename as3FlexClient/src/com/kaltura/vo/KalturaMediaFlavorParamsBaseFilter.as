package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFlavorParamsFilter;

	[Bindable]
	public dynamic class KalturaMediaFlavorParamsBaseFilter extends KalturaFlavorParamsFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
