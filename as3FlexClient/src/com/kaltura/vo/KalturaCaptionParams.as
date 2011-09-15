package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAssetParams;

	[Bindable]
	public dynamic class KalturaCaptionParams extends KalturaAssetParams
	{
		/** 
		* The language of the caption content
		* */ 
		public var language : String = null;

		/** 
		* Is default caption asset of the entry
		* */ 
		public var isDefault : int = int.MIN_VALUE;

		/** 
		* Friendly label
		* */ 
		public var label : String = null;

		/** 
		* The caption format
		* */ 
		public var format : String = null;

		/** 
		* Id of the caption params or the flavor params to be used as source for the caption creation		* */ 
		public var sourceParamsId : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('isDefault');
			arr.push('label');
			arr.push('sourceParamsId');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			arr.push('language');
			arr.push('format');
			return arr;
		}

	}
}
