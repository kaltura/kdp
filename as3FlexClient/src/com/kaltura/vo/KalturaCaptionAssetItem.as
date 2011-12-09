package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseEntry;

	import com.kaltura.vo.KalturaCaptionAsset;

	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaCaptionAssetItem extends BaseFlexVo
	{
		/** 
		* The Caption Asset object
		* */ 
		public var asset : KalturaCaptionAsset;

		/** 
		* The entry object
		* */ 
		public var entry : KalturaBaseEntry;

		/** 
		* 		* */ 
		public var startTime : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var endTime : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var content : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('asset');
			arr.push('entry');
			arr.push('startTime');
			arr.push('endTime');
			arr.push('content');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		* */ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}

	}
}
