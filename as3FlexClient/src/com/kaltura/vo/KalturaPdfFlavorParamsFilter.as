package com.kaltura.vo
{
	import com.kaltura.vo.KalturaPdfFlavorParamsBaseFilter;

	[Bindable]
	public dynamic class KalturaPdfFlavorParamsFilter extends KalturaPdfFlavorParamsBaseFilter
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
