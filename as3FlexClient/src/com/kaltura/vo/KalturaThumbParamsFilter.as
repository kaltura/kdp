package com.kaltura.vo
{
	import com.kaltura.vo.KalturaThumbParamsBaseFilter;

	[Bindable]
	public dynamic class KalturaThumbParamsFilter extends KalturaThumbParamsBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
