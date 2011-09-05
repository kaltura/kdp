package com.kaltura.vo
{
	import com.kaltura.vo.KalturaCuePointFilter;

	[Bindable]
	public dynamic class KalturaAnnotationBaseFilter extends KalturaCuePointFilter
	{
		/** 
		* 		* */ 
		public var parentIdEqual : String = null;

		/** 
		* 		* */ 
		public var parentIdIn : String = null;

		/** 
		* 		* */ 
		public var textLike : String = null;

		/** 
		* 		* */ 
		public var textMultiLikeOr : String = null;

		/** 
		* 		* */ 
		public var textMultiLikeAnd : String = null;

		/** 
		* 		* */ 
		public var endTimeGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var endTimeLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var durationGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var durationLessThanOrEqual : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('parentIdEqual');
			arr.push('parentIdIn');
			arr.push('textLike');
			arr.push('textMultiLikeOr');
			arr.push('textMultiLikeAnd');
			arr.push('endTimeGreaterThanOrEqual');
			arr.push('endTimeLessThanOrEqual');
			arr.push('durationGreaterThanOrEqual');
			arr.push('durationLessThanOrEqual');
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
