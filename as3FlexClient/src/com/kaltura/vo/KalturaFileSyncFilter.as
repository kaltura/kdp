package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFileSyncBaseFilter;

	[Bindable]
	public dynamic class KalturaFileSyncFilter extends KalturaFileSyncBaseFilter
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
