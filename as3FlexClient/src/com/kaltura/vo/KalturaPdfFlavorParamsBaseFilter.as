package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFlavorParamsFilter;

	[Bindable]
	public dynamic class KalturaPdfFlavorParamsBaseFilter extends KalturaFlavorParamsFilter
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
