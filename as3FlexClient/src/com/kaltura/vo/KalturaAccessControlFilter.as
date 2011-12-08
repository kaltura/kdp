package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAccessControlBaseFilter;

	[Bindable]
	public dynamic class KalturaAccessControlFilter extends KalturaAccessControlBaseFilter
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
