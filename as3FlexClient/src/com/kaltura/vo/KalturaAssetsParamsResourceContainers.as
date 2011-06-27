package com.kaltura.vo
{
	import com.kaltura.vo.KalturaResource;

	[Bindable]
	public dynamic class KalturaAssetsParamsResourceContainers extends KalturaResource
	{
		public var resources : Array = new Array();

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('resources');
			return arr;
		}
	}
}
