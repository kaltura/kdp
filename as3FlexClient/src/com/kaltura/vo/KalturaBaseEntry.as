package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaBaseEntry extends BaseFlexVo
	{
		/** 
		* Auto generated 10 characters alphanumeric string
		* */ 
		public var id : String = null;

		/** 
		* Entry name (Min 1 chars)
		* */ 
		public var name : String = null;

		/** 
		* Entry description
		* */ 
		public var description : String = null;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* The ID of the user who is the owner of this entry 
		* */ 
		public var userId : String = null;

		/** 
		* Entry tags
		* */ 
		public var tags : String = null;

		/** 
		* Entry admin tags can be updated only by administrators
		* */ 
		public var adminTags : String = null;

		/** 
		* 		* */ 
		public var categories : String = null;

		/** 
		* 		* */ 
		public var categoriesIds : String = null;

		/** 
		* 		* */ 
		public var status : String = null;

		/** 
		* Entry moderation status
		* */ 
		public var moderationStatus : int = int.MIN_VALUE;

		/** 
		* Number of moderation requests waiting for this entry
		* */ 
		public var moderationCount : int = int.MIN_VALUE;

		/** 
		* The type of the entry, this is auto filled by the derived entry object
		* */ 
		public var type : String = null;

		/** 
		* Entry creation date as Unix timestamp (In seconds)
		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* Entry update date as Unix timestamp (In seconds)
		* */ 
		public var updatedAt : int = int.MIN_VALUE;

		/** 
		* Calculated rank
		* */ 
		public var rank : Number = Number.NEGATIVE_INFINITY;

		/** 
		* The total (sum) of all votes
		* */ 
		public var totalRank : int = int.MIN_VALUE;

		/** 
		* Number of votes
		* */ 
		public var votes : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var groupId : int = int.MIN_VALUE;

		/** 
		* Can be used to store various partner related data as a string 
		* */ 
		public var partnerData : String = null;

		/** 
		* Download URL for the entry
		* */ 
		public var downloadUrl : String = null;

		/** 
		* Indexed search text for full text search		* */ 
		public var searchText : String = null;

		/** 
		* License type used for this entry
		* */ 
		public var licenseType : int = int.MIN_VALUE;

		/** 
		* Version of the entry data		* */ 
		public var version : int = int.MIN_VALUE;

		/** 
		* Thumbnail URL
		* */ 
		public var thumbnailUrl : String = null;

		/** 
		* The Access Control ID assigned to this entry (null when not set, send -1 to remove)  
		* */ 
		public var accessControlId : int = int.MIN_VALUE;

		/** 
		* Entry scheduling start date (null when not set, send -1 to remove)
		* */ 
		public var startDate : int = int.MIN_VALUE;

		/** 
		* Entry scheduling end date (null when not set, send -1 to remove)
		* */ 
		public var endDate : int = int.MIN_VALUE;

		/** 
		* Entry external reference id
		* */ 
		public var referenceId : String = null;

		/** 
		* ID of temporary entry that will replace this entry when it's approved and ready for replacement
		* */ 
		public var replacingEntryId : String = null;

		/** 
		* ID of the entry that will be replaced when the replacement approved and this entry is ready
		* */ 
		public var replacedEntryId : String = null;

		/** 
		* Status of the replacement readiness and approval
		* */ 
		public var replacementStatus : String = null;

		/** 
		* Can be used to store various partner related data as a numeric value
		* */ 
		public var partnerSortValue : int = int.MIN_VALUE;

		/** 
		* Override the default ingestion profile  
		* */ 
		public var conversionProfileId : int = int.MIN_VALUE;

		/** 
		* ID of source root entry, used for clipped, skipped and cropped entries that created from another entry  
		* */ 
		public var rootEntryId : String = null;

		/** 
		* clipping, skipping and cropping attributes that used to create this entry  
		* */ 
		public var operationAttributes : Array = new Array();

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('description');
			arr.push('userId');
			arr.push('tags');
			arr.push('adminTags');
			arr.push('categories');
			arr.push('categoriesIds');
			arr.push('type');
			arr.push('groupId');
			arr.push('partnerData');
			arr.push('licenseType');
			arr.push('accessControlId');
			arr.push('startDate');
			arr.push('endDate');
			arr.push('referenceId');
			arr.push('partnerSortValue');
			arr.push('conversionProfileId');
			arr.push('operationAttributes');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		* */ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('thumbnailUrl');
			return arr;
		}

		// required for backwards compatibility with an old, un-optimized client
		public function getParamKeys():Array { trace('backward incompatible'); throw new Error('backward incompatible');}
	}
}
