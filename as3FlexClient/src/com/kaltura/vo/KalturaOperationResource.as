package com.kaltura.vo
{
	import com.kaltura.vo.KalturaContentResource;

	import com.kaltura.vo.KalturaContentResource;

	[Bindable]
	public dynamic class KalturaOperationResource extends KalturaContentResource
	{
		/** 
		* Only KalturaEntryResource and KalturaAssetResource are supported		* */ 
		public var resource : KalturaContentResource;

		/** 
		* 		* */ 
		public var operationAttributes : Array = new Array();

		/** 
		* ID of alternative asset params to be used instead of the system default flavor params 		* */ 
		public var assetParamsId : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('resource');
			arr.push('operationAttributes');
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
