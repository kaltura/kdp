package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaBaseEntryBaseFilter extends KalturaFilter
	{
		/** 
		* This filter should be in use for retrieving only a specific entry (identified by its entryId).
@var string		* */ 
		public var idEqual : String = null;

		/** 
		* This filter should be in use for retrieving few specific entries (string should include comma separated list of entryId strings).
@var string		* */ 
		public var idIn : String = null;

		/** 
		* 		* */ 
		public var idNotIn : String = null;

		/** 
		* This filter should be in use for retrieving specific entries. It should include only one string to search for in entry names (no wildcards, spaces are treated as part of the string).
@var string		* */ 
		public var nameLike : String = null;

		/** 
		* This filter should be in use for retrieving specific entries. It could include few (comma separated) strings for searching in entry names, while applying an OR logic to retrieve entries that contain at least one input string (no wildcards, spaces are treated as part of the string).
@var string		* */ 
		public var nameMultiLikeOr : String = null;

		/** 
		* This filter should be in use for retrieving specific entries. It could include few (comma separated) strings for searching in entry names, while applying an AND logic to retrieve entries that contain all input strings (no wildcards, spaces are treated as part of the string).
@var string		* */ 
		public var nameMultiLikeAnd : String = null;

		/** 
		* This filter should be in use for retrieving entries with a specific name.
@var string		* */ 
		public var nameEqual : String = null;

		/** 
		* This filter should be in use for retrieving only entries which were uploaded by/assigned to users of a specific Kaltura Partner (identified by Partner ID).
@var int		* */ 
		public var partnerIdEqual : int = int.MIN_VALUE;

		/** 
		* This filter should be in use for retrieving only entries within Kaltura network which were uploaded by/assigned to users of few Kaltura Partners  (string should include comma separated list of PartnerIDs)
@var string		* */ 
		public var partnerIdIn : String = null;

		/** 
		* This filter parameter should be in use for retrieving only entries, uploaded by/assigned to a specific user (identified by user Id).
@var string		* */ 
		public var userIdEqual : String = null;

		/** 
		* This filter should be in use for retrieving specific entries. It should include only one string to search for in entry tags (no wildcards, spaces are treated as part of the string).
@var string		* */ 
		public var tagsLike : String = null;

		/** 
		* This filter should be in use for retrieving specific entries. It could include few (comma separated) strings for searching in entry tags, while applying an OR logic to retrieve entries that contain at least one input string (no wildcards, spaces are treated as part of the string).
@var string		* */ 
		public var tagsMultiLikeOr : String = null;

		/** 
		* This filter should be in use for retrieving specific entries. It could include few (comma separated) strings for searching in entry tags, while applying an AND logic to retrieve entries that contain all input strings (no wildcards, spaces are treated as part of the string).
@var string		* */ 
		public var tagsMultiLikeAnd : String = null;

		/** 
		* This filter should be in use for retrieving specific entries. It should include only one string to search for in entry tags set by an ADMIN user (no wildcards, spaces are treated as part of the string).
@var string		* */ 
		public var adminTagsLike : String = null;

		/** 
		* This filter should be in use for retrieving specific entries. It could include few (comma separated) strings for searching in entry tags, set by an ADMIN user, while applying an OR logic to retrieve entries that contain at least one input string (no wildcards, spaces are treated as part of the string).
@var string		* */ 
		public var adminTagsMultiLikeOr : String = null;

		/** 
		* This filter should be in use for retrieving specific entries. It could include few (comma separated) strings for searching in entry tags, set by an ADMIN user, while applying an AND logic to retrieve entries that contain all input strings (no wildcards, spaces are treated as part of the string).
@var string		* */ 
		public var adminTagsMultiLikeAnd : String = null;

		/** 
		* 		* */ 
		public var categoriesMatchAnd : String = null;

		/** 
		* 		* */ 
		public var categoriesMatchOr : String = null;

		/** 
		* 		* */ 
		public var categoriesIdsMatchAnd : String = null;

		/** 
		* 		* */ 
		public var categoriesIdsMatchOr : String = null;

		/** 
		* This filter should be in use for retrieving only entries, at a specific {@link ?object=KalturaEntryStatus KalturaEntryStatus}.
@var KalturaEntryStatus		* */ 
		public var statusEqual : String = null;

		/** 
		* This filter should be in use for retrieving only entries, not at a specific {@link ?object=KalturaEntryStatus KalturaEntryStatus}.
@var KalturaEntryStatus		* */ 
		public var statusNotEqual : String = null;

		/** 
		* This filter should be in use for retrieving only entries, at few specific {@link ?object=KalturaEntryStatus KalturaEntryStatus} (comma separated).
@dynamicType KalturaEntryStatus		* */ 
		public var statusIn : String = null;

		/** 
		* This filter should be in use for retrieving only entries, not at few specific {@link ?object=KalturaEntryStatus KalturaEntryStatus} (comma separated).
@dynamicType KalturaEntryStatus		* */ 
		public var statusNotIn : String = null;

		/** 
		* 		* */ 
		public var moderationStatusEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var moderationStatusNotEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var moderationStatusIn : String = null;

		/** 
		* 		* */ 
		public var moderationStatusNotIn : String = null;

		/** 
		* 		* */ 
		public var typeEqual : String = null;

		/** 
		* This filter should be in use for retrieving entries of few {@link ?object=KalturaEntryType KalturaEntryType} (string should include a comma separated list of {@link ?object=KalturaEntryType KalturaEntryType} enumerated parameters).
@dynamicType KalturaEntryType		* */ 
		public var typeIn : String = null;

		/** 
		* This filter parameter should be in use for retrieving only entries which were created at Kaltura system after a specific time/date (standard timestamp format).
@var int		* */ 
		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* This filter parameter should be in use for retrieving only entries which were created at Kaltura system before a specific time/date (standard timestamp format).
@var int		* */ 
		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var updatedAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var updatedAtLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var groupIdEqual : int = int.MIN_VALUE;

		/** 
		* This filter should be in use for retrieving specific entries while search match the input string within all of the following metadata attributes: name, description, tags, adminTags.
@var string		* */ 
		public var searchTextMatchAnd : String = null;

		/** 
		* This filter should be in use for retrieving specific entries while search match the input string within at least one of the following metadata attributes: name, description, tags, adminTags.
@var string		* */ 
		public var searchTextMatchOr : String = null;

		/** 
		* 		* */ 
		public var accessControlIdEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var accessControlIdIn : String = null;

		/** 
		* 		* */ 
		public var startDateGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var startDateLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var startDateGreaterThanOrEqualOrNull : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var startDateLessThanOrEqualOrNull : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var endDateGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var endDateLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var endDateGreaterThanOrEqualOrNull : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var endDateLessThanOrEqualOrNull : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var referenceIdEqual : String = null;

		/** 
		* 		* */ 
		public var referenceIdIn : String = null;

		/** 
		* 		* */ 
		public var replacingEntryIdEqual : String = null;

		/** 
		* 		* */ 
		public var replacingEntryIdIn : String = null;

		/** 
		* 		* */ 
		public var replacedEntryIdEqual : String = null;

		/** 
		* 		* */ 
		public var replacedEntryIdIn : String = null;

		/** 
		* 		* */ 
		public var replacementStatusEqual : String = null;

		/** 
		* 		* */ 
		public var replacementStatusIn : String = null;

		/** 
		* 		* */ 
		public var partnerSortValueGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerSortValueLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var rootEntryIdEqual : String = null;

		/** 
		* 		* */ 
		public var rootEntryIdIn : String = null;

		/** 
		* 		* */ 
		public var tagsNameMultiLikeOr : String = null;

		/** 
		* 		* */ 
		public var tagsAdminTagsMultiLikeOr : String = null;

		/** 
		* 		* */ 
		public var tagsAdminTagsNameMultiLikeOr : String = null;

		/** 
		* 		* */ 
		public var tagsNameMultiLikeAnd : String = null;

		/** 
		* 		* */ 
		public var tagsAdminTagsMultiLikeAnd : String = null;

		/** 
		* 		* */ 
		public var tagsAdminTagsNameMultiLikeAnd : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('idNotIn');
			arr.push('nameLike');
			arr.push('nameMultiLikeOr');
			arr.push('nameMultiLikeAnd');
			arr.push('nameEqual');
			arr.push('partnerIdEqual');
			arr.push('partnerIdIn');
			arr.push('userIdEqual');
			arr.push('tagsLike');
			arr.push('tagsMultiLikeOr');
			arr.push('tagsMultiLikeAnd');
			arr.push('adminTagsLike');
			arr.push('adminTagsMultiLikeOr');
			arr.push('adminTagsMultiLikeAnd');
			arr.push('categoriesMatchAnd');
			arr.push('categoriesMatchOr');
			arr.push('categoriesIdsMatchAnd');
			arr.push('categoriesIdsMatchOr');
			arr.push('statusEqual');
			arr.push('statusNotEqual');
			arr.push('statusIn');
			arr.push('statusNotIn');
			arr.push('moderationStatusEqual');
			arr.push('moderationStatusNotEqual');
			arr.push('moderationStatusIn');
			arr.push('moderationStatusNotIn');
			arr.push('typeEqual');
			arr.push('typeIn');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('updatedAtGreaterThanOrEqual');
			arr.push('updatedAtLessThanOrEqual');
			arr.push('groupIdEqual');
			arr.push('searchTextMatchAnd');
			arr.push('searchTextMatchOr');
			arr.push('accessControlIdEqual');
			arr.push('accessControlIdIn');
			arr.push('startDateGreaterThanOrEqual');
			arr.push('startDateLessThanOrEqual');
			arr.push('startDateGreaterThanOrEqualOrNull');
			arr.push('startDateLessThanOrEqualOrNull');
			arr.push('endDateGreaterThanOrEqual');
			arr.push('endDateLessThanOrEqual');
			arr.push('endDateGreaterThanOrEqualOrNull');
			arr.push('endDateLessThanOrEqualOrNull');
			arr.push('referenceIdEqual');
			arr.push('referenceIdIn');
			arr.push('replacingEntryIdEqual');
			arr.push('replacingEntryIdIn');
			arr.push('replacedEntryIdEqual');
			arr.push('replacedEntryIdIn');
			arr.push('replacementStatusEqual');
			arr.push('replacementStatusIn');
			arr.push('partnerSortValueGreaterThanOrEqual');
			arr.push('partnerSortValueLessThanOrEqual');
			arr.push('rootEntryIdEqual');
			arr.push('rootEntryIdIn');
			arr.push('tagsNameMultiLikeOr');
			arr.push('tagsAdminTagsMultiLikeOr');
			arr.push('tagsAdminTagsNameMultiLikeOr');
			arr.push('tagsNameMultiLikeAnd');
			arr.push('tagsAdminTagsMultiLikeAnd');
			arr.push('tagsAdminTagsNameMultiLikeAnd');
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
