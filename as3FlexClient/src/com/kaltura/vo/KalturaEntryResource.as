package com.kaltura.vo
{
	import com.kaltura.vo.KalturaContentResource;

	[Bindable]
	public dynamic class KalturaEntryResource extends KalturaContentResource
	{
		/** 
		* ID of the source entry 		* */ 
		public var entryId : String;

		/** 
		* ID of the source flavor params, set to null to use the source flavor		* */ 
		public var flavorParamsId : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('entryId');
			arr.push('flavorParamsId');
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
