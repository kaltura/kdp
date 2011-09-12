package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDocumentFlavorParamsOutputBaseFilter;

	[Bindable]
	public dynamic class KalturaDocumentFlavorParamsOutputFilter extends KalturaDocumentFlavorParamsOutputBaseFilter
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
