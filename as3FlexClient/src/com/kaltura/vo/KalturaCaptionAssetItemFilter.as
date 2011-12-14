package com.kaltura.vo
{
	import com.kaltura.vo.KalturaCaptionAssetFilter;

	[Bindable]
	public dynamic class KalturaCaptionAssetItemFilter extends KalturaCaptionAssetFilter
	{
		/** 
		* 		* */ 
		public var contentLike : String = null;

		/** 
		* 		* */ 
		public var contentMultiLikeOr : String = null;

		/** 
		* 		* */ 
		public var contentMultiLikeAnd : String = null;

		/** 
		* 		* */ 
		public var partnerDescriptionLike : String = null;

		/** 
		* 		* */ 
		public var partnerDescriptionMultiLikeOr : String = null;

		/** 
		* 		* */ 
		public var partnerDescriptionMultiLikeAnd : String = null;

		/** 
		* 		* */ 
		public var languageEqual : String = null;

		/** 
		* 		* */ 
		public var languageIn : String = null;

		/** 
		* 		* */ 
		public var labelEqual : String = null;

		/** 
		* 		* */ 
		public var labelIn : String = null;

		/** 
		* 		* */ 
		public var startTimeGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var startTimeLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var endTimeGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var endTimeLessThanOrEqual : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('contentLike');
			arr.push('contentMultiLikeOr');
			arr.push('contentMultiLikeAnd');
			arr.push('partnerDescriptionLike');
			arr.push('partnerDescriptionMultiLikeOr');
			arr.push('partnerDescriptionMultiLikeAnd');
			arr.push('languageEqual');
			arr.push('languageIn');
			arr.push('labelEqual');
			arr.push('labelIn');
			arr.push('startTimeGreaterThanOrEqual');
			arr.push('startTimeLessThanOrEqual');
			arr.push('endTimeGreaterThanOrEqual');
			arr.push('endTimeLessThanOrEqual');
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
