package com.kaltura.vo
{
	import com.kaltura.vo.KalturaWidgetBaseFilter;

	[Bindable]
	public dynamic class KalturaWidgetFilter extends KalturaWidgetBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
