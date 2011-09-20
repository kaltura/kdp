package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFlavorParams;

	[Bindable]
	public dynamic class KalturaFlavorParamsOutput extends KalturaFlavorParams
	{
		/** 
		* 		* */ 
		public var flavorParamsId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var commandLinesStr : String = null;

		/** 
		* 		* */ 
		public var flavorParamsVersion : String = null;

		/** 
		* 		* */ 
		public var flavorAssetId : String = null;

		/** 
		* 		* */ 
		public var flavorAssetVersion : String = null;

		/** 
		* 		* */ 
		public var readyBehavior : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('flavorParamsId');
			arr.push('commandLinesStr');
			arr.push('flavorParamsVersion');
			arr.push('flavorAssetId');
			arr.push('flavorAssetVersion');
			arr.push('readyBehavior');
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
