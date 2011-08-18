package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaCuePoint extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var id : String = null;

		/** 
		* 		* */ 
		public var cuePointType : String = null;

		/** 
		* 		* */ 
		public var status : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var entryId : String = null;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var updatedAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var tags : String = null;

		/** 
		* Start tim ein milliseconds		* */ 
		public var startTime : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var userId : String = null;

		/** 
		* 		* */ 
		public var partnerData : String = null;

		/** 
		* 		* */ 
		public var partnerSortValue : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var forceStop : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var thumbOffset : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var systemName : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('tags');
			arr.push('startTime');
			arr.push('partnerData');
			arr.push('partnerSortValue');
			arr.push('forceStop');
			arr.push('thumbOffset');
			arr.push('systemName');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		* */ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('entryId');
			return arr;
		}

	}
}
