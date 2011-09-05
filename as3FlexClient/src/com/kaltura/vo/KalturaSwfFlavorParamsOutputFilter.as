package com.kaltura.vo
{
	import com.kaltura.vo.KalturaSwfFlavorParamsOutputBaseFilter;

	[Bindable]
	public dynamic class KalturaSwfFlavorParamsOutputFilter extends KalturaSwfFlavorParamsOutputBaseFilter
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
