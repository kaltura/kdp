package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAdminUserBaseFilter;

	[Bindable]
	public dynamic class KalturaAdminUserFilter extends KalturaAdminUserBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
