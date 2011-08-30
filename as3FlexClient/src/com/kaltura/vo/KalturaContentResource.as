package com.kaltura.vo
{
	import com.kaltura.vo.KalturaResource;

	[Bindable]
	public dynamic class KalturaContentResource extends KalturaResource
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
