package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAsset;

	[Bindable]
	public dynamic class KalturaThumbAsset extends KalturaAsset
	{
		/** 
		* The Flavor Params used to create this Flavor Asset
		* */ 
		public var thumbParamsId : int = int.MIN_VALUE;

		/** 
		* The width of the Flavor Asset 
		* */ 
		public var width : int = int.MIN_VALUE;

		/** 
		* The height of the Flavor Asset
		* */ 
		public var height : int = int.MIN_VALUE;

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
			arr.push('thumbParamsId');
			return arr;
		}

	}
}
