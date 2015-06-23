// ===================================================================================================
//                           _  __     _ _
//                          | |/ /__ _| | |_ _  _ _ _ __ _
//                          | ' </ _` | |  _| || | '_/ _` |
//                          |_|\_\__,_|_|\__|\_,_|_| \__,_|
//
// This file is part of the Kaltura Collaborative Media Suite which allows users
// to do with audio, video, and animation what Wiki platfroms allow them to do with
// text.
//
// Copyright (C) 2006-2011  Kaltura Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
// @ignore
// ===================================================================================================
package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaBaseEntryBaseFilter extends KalturaFilter
	{
		/**
		* This filter should be in use for retrieving only a specific entry (identified by its entryId).
		* 
		**/
		public var idEqual : String = null;

		/**
		* This filter should be in use for retrieving few specific entries (string should include comma separated list of entryId strings).
		* 
		**/
		public var idIn : String = null;

		/**
		**/
		public var idNotIn : String = null;

		/**
		* This filter should be in use for retrieving specific entries. It should include only one string to search for in entry names (no wildcards, spaces are treated as part of the string).
		* 
		**/
		public var nameLike : String = null;

		/**
		* This filter should be in use for retrieving specific entries. It could include few (comma separated) strings for searching in entry names, while applying an OR logic to retrieve entries that contain at least one input string (no wildcards, spaces are treated as part of the string).
		* 
		**/
		public var nameMultiLikeOr : String = null;

		/**
		* This filter should be in use for retrieving specific entries. It could include few (comma separated) strings for searching in entry names, while applying an AND logic to retrieve entries that contain all input strings (no wildcards, spaces are treated as part of the string).
		* 
		**/
		public var nameMultiLikeAnd : String = null;

		/**
		* This filter should be in use for retrieving entries with a specific name.
		* 
		**/
		public var nameEqual : String = null;

		/**
		* This filter should be in use for retrieving only entries which were uploaded by/assigned to users of a specific Kaltura Partner (identified by Partner ID).
		* 
		**/
		public var partnerIdEqual : int = int.MIN_VALUE;

		/**
		* This filter should be in use for retrieving only entries within Kaltura network which were uploaded by/assigned to users of few Kaltura Partners  (string should include comma separated list of PartnerIDs)
		* 
		**/
		public var partnerIdIn : String = null;

		/**
		* This filter parameter should be in use for retrieving only entries, uploaded by/assigned to a specific user (identified by user Id).
		* 
		**/
		public var userIdEqual : String = null;

		/**
		**/
		public var creatorIdEqual : String = null;

		/**
		* This filter should be in use for retrieving specific entries. It should include only one string to search for in entry tags (no wildcards, spaces are treated as part of the string).
		* 
		**/
		public var tagsLike : String = null;

		/**
		* This filter should be in use for retrieving specific entries. It could include few (comma separated) strings for searching in entry tags, while applying an OR logic to retrieve entries that contain at least one input string (no wildcards, spaces are treated as part of the string).
		* 
		**/
		public var tagsMultiLikeOr : String = null;

		/**
		* This filter should be in use for retrieving specific entries. It could include few (comma separated) strings for searching in entry tags, while applying an AND logic to retrieve entries that contain all input strings (no wildcards, spaces are treated as part of the string).
		* 
		**/
		public var tagsMultiLikeAnd : String = null;

		/**
		* This filter should be in use for retrieving specific entries. It should include only one string to search for in entry tags set by an ADMIN user (no wildcards, spaces are treated as part of the string).
		* 
		**/
		public var adminTagsLike : String = null;

		/**
		* This filter should be in use for retrieving specific entries. It could include few (comma separated) strings for searching in entry tags, set by an ADMIN user, while applying an OR logic to retrieve entries that contain at least one input string (no wildcards, spaces are treated as part of the string).
		* 
		**/
		public var adminTagsMultiLikeOr : String = null;

		/**
		* This filter should be in use for retrieving specific entries. It could include few (comma separated) strings for searching in entry tags, set by an ADMIN user, while applying an AND logic to retrieve entries that contain all input strings (no wildcards, spaces are treated as part of the string).
		* 
		**/
		public var adminTagsMultiLikeAnd : String = null;

		/**
		**/
		public var categoriesMatchAnd : String = null;

		/**
		* All entries within these categories or their child categories.
		* 
		**/
		public var categoriesMatchOr : String = null;

		/**
		**/
		public var categoriesNotContains : String = null;

		/**
		**/
		public var categoriesIdsMatchAnd : String = null;

		/**
		* All entries of the categories, excluding their child categories.
		* To include entries of the child categories, use categoryAncestorIdIn, or categoriesMatchOr.
		* 
		**/
		public var categoriesIdsMatchOr : String = null;

		/**
		**/
		public var categoriesIdsNotContains : String = null;

		/**
		* @see com.kaltura.types.KalturaNullableBoolean
		**/
		public var categoriesIdsEmpty : int = int.MIN_VALUE;

		/**
		* This filter should be in use for retrieving only entries, at a specific {
		* @see com.kaltura.types.KalturaEntryStatus
		**/
		public var statusEqual : String = null;

		/**
		* This filter should be in use for retrieving only entries, not at a specific {
		* @see com.kaltura.types.KalturaEntryStatus
		**/
		public var statusNotEqual : String = null;

		/**
		* This filter should be in use for retrieving only entries, at few specific {
		**/
		public var statusIn : String = null;

		/**
		* This filter should be in use for retrieving only entries, not at few specific {
		**/
		public var statusNotIn : String = null;

		/**
		* @see com.kaltura.types.KalturaEntryModerationStatus
		**/
		public var moderationStatusEqual : int = int.MIN_VALUE;

		/**
		* @see com.kaltura.types.KalturaEntryModerationStatus
		**/
		public var moderationStatusNotEqual : int = int.MIN_VALUE;

		/**
		**/
		public var moderationStatusIn : String = null;

		/**
		**/
		public var moderationStatusNotIn : String = null;

		/**
		* @see com.kaltura.types.KalturaEntryType
		**/
		public var typeEqual : String = null;

		/**
		* This filter should be in use for retrieving entries of few {
		**/
		public var typeIn : String = null;

		/**
		* This filter parameter should be in use for retrieving only entries which were created at Kaltura system after a specific time/date (standard timestamp format).
		* 
		**/
		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		* This filter parameter should be in use for retrieving only entries which were created at Kaltura system before a specific time/date (standard timestamp format).
		* 
		**/
		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;

		/**
		**/
		public var updatedAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		**/
		public var updatedAtLessThanOrEqual : int = int.MIN_VALUE;

		/**
		**/
		public var totalRankLessThanOrEqual : int = int.MIN_VALUE;

		/**
		**/
		public var totalRankGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		**/
		public var groupIdEqual : int = int.MIN_VALUE;

		/**
		* This filter should be in use for retrieving specific entries while search match the input string within all of the following metadata attributes: name, description, tags, adminTags.
		* 
		**/
		public var searchTextMatchAnd : String = null;

		/**
		* This filter should be in use for retrieving specific entries while search match the input string within at least one of the following metadata attributes: name, description, tags, adminTags.
		* 
		**/
		public var searchTextMatchOr : String = null;

		/**
		**/
		public var accessControlIdEqual : int = int.MIN_VALUE;

		/**
		**/
		public var accessControlIdIn : String = null;

		/**
		**/
		public var startDateGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		**/
		public var startDateLessThanOrEqual : int = int.MIN_VALUE;

		/**
		**/
		public var startDateGreaterThanOrEqualOrNull : int = int.MIN_VALUE;

		/**
		**/
		public var startDateLessThanOrEqualOrNull : int = int.MIN_VALUE;

		/**
		**/
		public var endDateGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		**/
		public var endDateLessThanOrEqual : int = int.MIN_VALUE;

		/**
		**/
		public var endDateGreaterThanOrEqualOrNull : int = int.MIN_VALUE;

		/**
		**/
		public var endDateLessThanOrEqualOrNull : int = int.MIN_VALUE;

		/**
		**/
		public var referenceIdEqual : String = null;

		/**
		**/
		public var referenceIdIn : String = null;

		/**
		**/
		public var replacingEntryIdEqual : String = null;

		/**
		**/
		public var replacingEntryIdIn : String = null;

		/**
		**/
		public var replacedEntryIdEqual : String = null;

		/**
		**/
		public var replacedEntryIdIn : String = null;

		/**
		* @see com.kaltura.types.KalturaEntryReplacementStatus
		**/
		public var replacementStatusEqual : String = null;

		/**
		**/
		public var replacementStatusIn : String = null;

		/**
		**/
		public var partnerSortValueGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		**/
		public var partnerSortValueLessThanOrEqual : int = int.MIN_VALUE;

		/**
		**/
		public var rootEntryIdEqual : String = null;

		/**
		**/
		public var rootEntryIdIn : String = null;

		/**
		**/
		public var tagsNameMultiLikeOr : String = null;

		/**
		**/
		public var tagsAdminTagsMultiLikeOr : String = null;

		/**
		**/
		public var tagsAdminTagsNameMultiLikeOr : String = null;

		/**
		**/
		public var tagsNameMultiLikeAnd : String = null;

		/**
		**/
		public var tagsAdminTagsMultiLikeAnd : String = null;

		/**
		**/
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
			arr.push('creatorIdEqual');
			arr.push('tagsLike');
			arr.push('tagsMultiLikeOr');
			arr.push('tagsMultiLikeAnd');
			arr.push('adminTagsLike');
			arr.push('adminTagsMultiLikeOr');
			arr.push('adminTagsMultiLikeAnd');
			arr.push('categoriesMatchAnd');
			arr.push('categoriesMatchOr');
			arr.push('categoriesNotContains');
			arr.push('categoriesIdsMatchAnd');
			arr.push('categoriesIdsMatchOr');
			arr.push('categoriesIdsNotContains');
			arr.push('categoriesIdsEmpty');
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
			arr.push('totalRankLessThanOrEqual');
			arr.push('totalRankGreaterThanOrEqual');
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

		override public function getElementType(arrayName:String):String
		{
			var result:String = '';
			switch (arrayName) {
				default:
					result = super.getElementType(arrayName);
					break;
			}
			return result;
		}
	}
}
