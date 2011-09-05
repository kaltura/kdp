package com.kaltura.vo
{
	import com.kaltura.vo.KalturaThumbAssetBaseFilter;

	[Bindable]
	public dynamic class KalturaThumbAssetFilter extends KalturaThumbAssetBaseFilter
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
