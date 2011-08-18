package com.kaltura.vo
{
	import com.kaltura.vo.KalturaContentResource;

	[Bindable]
	public dynamic class KalturaDataCenterContentResource extends KalturaContentResource
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
