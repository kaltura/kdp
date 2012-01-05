package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFlavorParamsBaseFilter;

	[Bindable]
	public dynamic class KalturaFlavorParamsFilter extends KalturaFlavorParamsBaseFilter
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
