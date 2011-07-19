package com.kaltura.vo
{
	import com.kaltura.vo.KalturaSystemUserBaseFilter;

	[Bindable]
	public dynamic class KalturaSystemUserFilter extends KalturaSystemUserBaseFilter
	{
override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
