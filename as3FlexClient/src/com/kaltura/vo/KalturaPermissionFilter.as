package com.kaltura.vo
{
	import com.kaltura.vo.KalturaPermissionBaseFilter;

	[Bindable]
	public dynamic class KalturaPermissionFilter extends KalturaPermissionBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
