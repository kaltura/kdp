package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaBaseEntryBaseFilter extends KalturaFilter
	{
		public var idEqual : String;

		public var idIn : String;

		public var idNotIn : String;

		public var nameLike : String;

		public var nameMultiLikeOr : String;

		public var nameMultiLikeAnd : String;

		public var nameEqual : String;

		public var partnerIdEqual : int = int.MIN_VALUE;

		public var partnerIdIn : String;

		public var userIdEqual : String;

		public var tagsLike : String;

		public var tagsMultiLikeOr : String;

		public var tagsMultiLikeAnd : String;

		public var adminTagsLike : String;

		public var adminTagsMultiLikeOr : String;

		public var adminTagsMultiLikeAnd : String;

		public var categoriesMatchAnd : String;

		public var categoriesMatchOr : String;

		public var categoriesIdsMatchAnd : String;

		public var categoriesIdsMatchOr : String;

		public var statusEqual : String;

		public var statusNotEqual : String;

		public var statusIn : String;

		public var statusNotIn : String;

		public var moderationStatusEqual : int = int.MIN_VALUE;

		public var moderationStatusNotEqual : int = int.MIN_VALUE;

		public var moderationStatusIn : String;

		public var moderationStatusNotIn : String;

		public var typeEqual : String;

		public var typeIn : String;

		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;

		public var updatedAtGreaterThanOrEqual : int = int.MIN_VALUE;

		public var updatedAtLessThanOrEqual : int = int.MIN_VALUE;

		public var groupIdEqual : int = int.MIN_VALUE;

		public var searchTextMatchAnd : String;

		public var searchTextMatchOr : String;

		public var accessControlIdEqual : int = int.MIN_VALUE;

		public var accessControlIdIn : String;

		public var startDateGreaterThanOrEqual : int = int.MIN_VALUE;

		public var startDateLessThanOrEqual : int = int.MIN_VALUE;

		public var startDateGreaterThanOrEqualOrNull : int = int.MIN_VALUE;

		public var startDateLessThanOrEqualOrNull : int = int.MIN_VALUE;

		public var endDateGreaterThanOrEqual : int = int.MIN_VALUE;

		public var endDateLessThanOrEqual : int = int.MIN_VALUE;

		public var endDateGreaterThanOrEqualOrNull : int = int.MIN_VALUE;

		public var endDateLessThanOrEqualOrNull : int = int.MIN_VALUE;

		public var referenceIdEqual : String;

		public var referenceIdIn : String;

		public var replacingEntryIdEqual : String;

		public var replacingEntryIdIn : String;

		public var replacedEntryIdEqual : String;

		public var replacedEntryIdIn : String;

		public var replacementStatusEqual : String;

		public var replacementStatusIn : String;

		public var partnerSortValueGreaterThanOrEqual : int = int.MIN_VALUE;

		public var partnerSortValueLessThanOrEqual : int = int.MIN_VALUE;

		public var tagsNameMultiLikeOr : String;

		public var tagsAdminTagsMultiLikeOr : String;

		public var tagsAdminTagsNameMultiLikeOr : String;

		public var tagsNameMultiLikeAnd : String;

		public var tagsAdminTagsMultiLikeAnd : String;

		public var tagsAdminTagsNameMultiLikeAnd : String;

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
			arr.push('tagsNameMultiLikeOr');
			arr.push('tagsAdminTagsMultiLikeOr');
			arr.push('tagsAdminTagsNameMultiLikeOr');
			arr.push('tagsNameMultiLikeAnd');
			arr.push('tagsAdminTagsMultiLikeAnd');
			arr.push('tagsAdminTagsNameMultiLikeAnd');
			return arr;
		}
	}
}
