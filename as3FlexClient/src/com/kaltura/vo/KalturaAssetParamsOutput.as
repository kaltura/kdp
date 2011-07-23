package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAssetParams;

	[Bindable]
	public dynamic class KalturaAssetParamsOutput extends KalturaAssetParams
	{
		/** 
		* 		* */ 
		public var assetParamsId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var assetParamsVersion : String;

		/** 
		* 		* */ 
		public var assetId : String;

		/** 
		* 		* */ 
		public var assetVersion : String;

		/** 
		* 		* */ 
		public var readyBehavior : int = int.MIN_VALUE;

		/** 
		* The container format of the Flavor Params
		* */ 
		public var format : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('assetParamsId');
			arr.push('assetParamsVersion');
			arr.push('assetId');
			arr.push('assetVersion');
			arr.push('readyBehavior');
			arr.push('format');
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
