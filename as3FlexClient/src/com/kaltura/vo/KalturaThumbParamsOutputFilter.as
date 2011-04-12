package com.kaltura.vo
{
	import com.kaltura.vo.KalturaThumbParamsOutputBaseFilter;

	[Bindable]
	public dynamic class KalturaThumbParamsOutputFilter extends KalturaThumbParamsOutputBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
