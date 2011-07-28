package com.kaltura.vo
{
	import com.kaltura.vo.KalturaContentResource;

	import com.kaltura.vo.KalturaResource;

	[Bindable]
	public dynamic class KalturaAssetParamsResourceContainer extends KalturaResource
	{
		/** 
		* The content resource to associate with asset params		* */ 
		public var resource : KalturaContentResource;

		/** 
		* The asset params to associate with the reaource		* */ 
		public var assetParamsId : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('resource');
			arr.push('assetParamsId');
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
