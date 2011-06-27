package com.kaltura.vo
{
	import com.kaltura.vo.KalturaUserFilter;

	[Bindable]
	public dynamic class KalturaAdminUserBaseFilter extends KalturaUserFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
