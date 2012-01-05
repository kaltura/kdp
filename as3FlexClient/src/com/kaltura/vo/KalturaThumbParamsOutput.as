package com.kaltura.vo
{
	import com.kaltura.vo.KalturaThumbParams;

	[Bindable]
	public dynamic class KalturaThumbParamsOutput extends KalturaThumbParams
	{
		/** 
		* 		* */ 
		public var thumbParamsId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var thumbParamsVersion : String = null;

		/** 
		* 		* */ 
		public var thumbAssetId : String = null;

		/** 
		* 		* */ 
		public var thumbAssetVersion : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('thumbParamsId');
			arr.push('thumbParamsVersion');
			arr.push('thumbAssetId');
			arr.push('thumbAssetVersion');
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
