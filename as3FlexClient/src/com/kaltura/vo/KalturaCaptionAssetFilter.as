package com.kaltura.vo
{
	import com.kaltura.vo.KalturaCaptionAssetBaseFilter;

	[Bindable]
	public dynamic class KalturaCaptionAssetFilter extends KalturaCaptionAssetBaseFilter
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
