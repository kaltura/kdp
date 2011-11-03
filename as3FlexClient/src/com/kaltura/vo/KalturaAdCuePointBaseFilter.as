package com.kaltura.vo
{
	import com.kaltura.vo.KalturaCuePointFilter;

	[Bindable]
	public dynamic class KalturaAdCuePointBaseFilter extends KalturaCuePointFilter
	{
		/** 
		* 		* */ 
		public var protocolTypeEqual : String = null;

		/** 
		* 		* */ 
		public var protocolTypeIn : String = null;

		/** 
		* 		* */ 
		public var titleLike : String = null;

		/** 
		* 		* */ 
		public var titleMultiLikeOr : String = null;

		/** 
		* 		* */ 
		public var titleMultiLikeAnd : String = null;

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
			arr.push('protocolTypeEqual');
			arr.push('protocolTypeIn');
			arr.push('titleLike');
			arr.push('titleMultiLikeOr');
			arr.push('titleMultiLikeAnd');
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
