package com.kaltura.vo
{
	import com.kaltura.vo.KalturaResource;

	[Bindable]
	public dynamic class KalturaAssetsParamsResourceContainers extends KalturaResource
	{
		/** 
		* Array of resources associated with asset params ids		* */ 
		public var resources : Array = new Array();

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('resources');
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
