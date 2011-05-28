package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFlavorParamsOutput;

	[Bindable]
	public dynamic class KalturaMediaFlavorParamsOutput extends KalturaFlavorParamsOutput
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
