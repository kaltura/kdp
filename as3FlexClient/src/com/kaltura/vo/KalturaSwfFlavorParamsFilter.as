package com.kaltura.vo
{
	import com.kaltura.vo.KalturaSwfFlavorParamsBaseFilter;

	[Bindable]
	public dynamic class KalturaSwfFlavorParamsFilter extends KalturaSwfFlavorParamsBaseFilter
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
