package com.kaltura.vo
{
	import com.kaltura.vo.KalturaContentResource;

	[Bindable]
	public dynamic class KalturaAssetResource extends KalturaContentResource
	{
		/** 
		* ID of the source asset 		* */ 
		public var assetId : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('assetId');
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
