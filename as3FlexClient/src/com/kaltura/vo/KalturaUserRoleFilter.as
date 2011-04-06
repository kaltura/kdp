package com.kaltura.vo
{
	import com.kaltura.vo.KalturaUserRoleBaseFilter;

	[Bindable]
	public dynamic class KalturaUserRoleFilter extends KalturaUserRoleBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
