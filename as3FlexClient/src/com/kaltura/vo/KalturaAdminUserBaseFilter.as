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

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

	}
}
