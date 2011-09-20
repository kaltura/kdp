package com.kaltura.vo
{
	import com.kaltura.vo.KalturaStorageProfileBaseFilter;

	[Bindable]
	public dynamic class KalturaStorageProfileFilter extends KalturaStorageProfileBaseFilter
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
