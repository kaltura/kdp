package com.kaltura.vo
{
	import com.kaltura.vo.KalturaMediaInfoBaseFilter;

	[Bindable]
	public dynamic class KalturaMediaInfoFilter extends KalturaMediaInfoBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
