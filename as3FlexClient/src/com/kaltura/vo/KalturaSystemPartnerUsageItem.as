package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaSystemPartnerUsageItem extends BaseFlexVo
	{
		/** 
		* Partner ID
		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* Partner name
		* */ 
		public var partnerName : String = null;

		/** 
		* Partner status
		* */ 
		public var partnerStatus : int = int.MIN_VALUE;

		/** 
		* Partner package
		* */ 
		public var partnerPackage : int = int.MIN_VALUE;

		/** 
		* Partner creation date (Unix timestamp)
		* */ 
		public var partnerCreatedAt : int = int.MIN_VALUE;

		/** 
		* Number of player loads in the specific date range
		* */ 
		public var views : int = int.MIN_VALUE;

		/** 
		* Number of plays in the specific date range
		* */ 
		public var plays : int = int.MIN_VALUE;

		/** 
		* Number of new entries created during specific date range
		* */ 
		public var entriesCount : int = int.MIN_VALUE;

		/** 
		* Total number of entries
		* */ 
		public var totalEntriesCount : int = int.MIN_VALUE;

		/** 
		* Number of new video entries created during specific date range
		* */ 
		public var videoEntriesCount : int = int.MIN_VALUE;

		/** 
		* Number of new image entries created during specific date range
		* */ 
		public var imageEntriesCount : int = int.MIN_VALUE;

		/** 
		* Number of new audio entries created during specific date range
		* */ 
		public var audioEntriesCount : int = int.MIN_VALUE;

		/** 
		* Number of new mix entries created during specific date range
		* */ 
		public var mixEntriesCount : int = int.MIN_VALUE;

		/** 
		* The total bandwidth usage during the given date range (in MB)
		* */ 
		public var bandwidth : Number = Number.NEGATIVE_INFINITY;

		/** 
		* The total storage consumption (in MB)
		* */ 
		public var totalStorage : Number = Number.NEGATIVE_INFINITY;

		/** 
		* The change in storage consumption (new uploads) during the given date range (in MB)
		* */ 
		public var storage : Number = Number.NEGATIVE_INFINITY;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('partnerId');
			arr.push('partnerName');
			arr.push('partnerStatus');
			arr.push('partnerPackage');
			arr.push('partnerCreatedAt');
			arr.push('views');
			arr.push('plays');
			arr.push('entriesCount');
			arr.push('totalEntriesCount');
			arr.push('videoEntriesCount');
			arr.push('imageEntriesCount');
			arr.push('audioEntriesCount');
			arr.push('mixEntriesCount');
			arr.push('bandwidth');
			arr.push('totalStorage');
			arr.push('storage');
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
