package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFlavorParams;

	[Bindable]
	public dynamic class KalturaDocumentFlavorParams extends KalturaFlavorParams
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
