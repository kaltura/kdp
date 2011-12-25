package com.kaltura.vo
{
	import com.kaltura.vo.KalturaCuePointFilter;

	[Bindable]
	public dynamic class KalturaCodeCuePointBaseFilter extends KalturaCuePointFilter
	{
		/** 
		* 		* */ 
		public var codeLike : String = null;

		/** 
		* 		* */ 
		public var codeMultiLikeOr : String = null;

		/** 
		* 		* */ 
		public var codeMultiLikeAnd : String = null;

		/** 
		* 		* */ 
		public var codeEqual : String = null;

		/** 
		* 		* */ 
		public var codeIn : String = null;

		/** 
		* 		* */ 
		public var descriptionLike : String = null;

		/** 
		* 		* */ 
		public var descriptionMultiLikeOr : String = null;

		/** 
		* 		* */ 
		public var descriptionMultiLikeAnd : String = null;

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
			arr.push('codeLike');
			arr.push('codeMultiLikeOr');
			arr.push('codeMultiLikeAnd');
			arr.push('codeEqual');
			arr.push('codeIn');
			arr.push('descriptionLike');
			arr.push('descriptionMultiLikeOr');
			arr.push('descriptionMultiLikeAnd');
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
