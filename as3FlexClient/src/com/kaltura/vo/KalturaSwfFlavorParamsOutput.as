package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFlavorParamsOutput;

	[Bindable]
	public dynamic class KalturaSwfFlavorParamsOutput extends KalturaFlavorParamsOutput
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
