package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFlavorParams;

	[Bindable]
	public dynamic class KalturaMediaFlavorParams extends KalturaFlavorParams
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
