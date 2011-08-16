package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAnnotationBaseFilter;

	[Bindable]
	public dynamic class KalturaAnnotationFilter extends KalturaAnnotationBaseFilter
	{
override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
