package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseJobBaseFilter;

	[Bindable]
	public dynamic class KalturaBaseJobFilter extends KalturaBaseJobBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
