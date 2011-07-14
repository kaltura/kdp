package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAsset;

	[Bindable]
	public dynamic class KalturaCaptionAsset extends KalturaAsset
	{
		/** 
		* The Caption Params used to create this Caption Asset
		* */ 
		public var captionParamsId : int = int.MIN_VALUE;

		/** 
		* The language of the caption asset content
		* */ 
		public var language : String;

		/** 
		* Is default caption asset of the entry
		* */ 
		public var isDefault : int = int.MIN_VALUE;

		/** 
		* Friendly label
		* */ 
		public var label : String;

		/** 
		* The caption format
		* */ 
		public var format : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('isDefault');
			arr.push('label');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			arr.push('captionParamsId');
			arr.push('language');
			arr.push('format');
			return arr;
		}

	}
}
