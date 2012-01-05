package com.kaltura.vo
{
	import com.kaltura.vo.KalturaUserLoginDataBaseFilter;

	[Bindable]
	public dynamic class KalturaUserLoginDataFilter extends KalturaUserLoginDataBaseFilter
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
