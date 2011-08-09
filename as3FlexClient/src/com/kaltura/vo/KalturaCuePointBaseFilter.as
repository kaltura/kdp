package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaCuePointBaseFilter extends KalturaFilter
	{
		/** 
		* 		* */ 
		public var idEqual : String;

		/** 
		* 		* */ 
		public var idIn : String;

		/** 
		* 		* */ 
		public var cuePointTypeEqual : String;

		/** 
		* 		* */ 
		public var cuePointTypeIn : String;

		/** 
		* 		* */ 
		public var statusEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var statusIn : String;

		/** 
		* 		* */ 
		public var entryIdEqual : String;

		/** 
		* 		* */ 
		public var entryIdIn : String;

		/** 
		* 		* */ 
		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var updatedAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var updatedAtLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var startTimeGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var startTimeLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var userIdEqual : String;

		/** 
		* 		* */ 
		public var userIdIn : String;

		/** 
		* 		* */ 
		public var partnerSortValueEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerSortValueIn : String;

		/** 
		* 		* */ 
		public var partnerSortValueGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerSortValueLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var forceStopEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var systemNameEqual : String;

		/** 
		* 		* */ 
		public var systemNameIn : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('cuePointTypeEqual');
			arr.push('cuePointTypeIn');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('entryIdEqual');
			arr.push('entryIdIn');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('updatedAtGreaterThanOrEqual');
			arr.push('updatedAtLessThanOrEqual');
			arr.push('startTimeGreaterThanOrEqual');
			arr.push('startTimeLessThanOrEqual');
			arr.push('userIdEqual');
			arr.push('userIdIn');
			arr.push('partnerSortValueEqual');
			arr.push('partnerSortValueIn');
			arr.push('partnerSortValueGreaterThanOrEqual');
			arr.push('partnerSortValueLessThanOrEqual');
			arr.push('forceStopEqual');
			arr.push('systemNameEqual');
			arr.push('systemNameIn');
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
