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
	import com.kaltura.vo.BaseFlexVo;

	[Bindable]
	public dynamic class KalturaBaseEntry extends BaseFlexVo
	{
		/**
		* Auto generated 10 characters alphanumeric string
		* 
		**/
		public var id : String = null;

		/**
		* Entry name (Min 1 chars)
		* 
		**/
		public var name : String = null;

		/**
		* Entry description
		* 
		**/
		public var description : String = null;

		/**
		**/
		public var partnerId : int = int.MIN_VALUE;

		/**
		* The ID of the user who is the owner of this entry
		* 
		**/
		public var userId : String = null;

		/**
		* The ID of the user who created this entry
		* 
		**/
		public var creatorId : String = null;

		/**
		* Entry tags
		* 
		**/
		public var tags : String = null;

		/**
		* Entry admin tags can be updated only by administrators
		* 
		**/
		public var adminTags : String = null;

		/**
		* Categories with no entitlement that this entry belongs to.
		* 
		**/
		public var categories : String = null;

		/**
		* Categories Ids of categories with no entitlement that this entry belongs to
		* 
		**/
		public var categoriesIds : String = null;

		/**
		* @see com.kaltura.types.KalturaEntryStatus
		**/
		public var status : String = null;

		/**
		* Entry moderation status
		* 
		* @see com.kaltura.types.KalturaEntryModerationStatus
		**/
		public var moderationStatus : int = int.MIN_VALUE;

		/**
		* Number of moderation requests waiting for this entry
		* 
		**/
		public var moderationCount : int = int.MIN_VALUE;

		/**
		* The type of the entry, this is auto filled by the derived entry object
		* 
		* @see com.kaltura.types.KalturaEntryType
		**/
		public var type : String = null;

		/**
		* Entry creation date as Unix timestamp (In seconds)
		* 
		**/
		public var createdAt : int = int.MIN_VALUE;

		/**
		* Entry update date as Unix timestamp (In seconds)
		* 
		**/
		public var updatedAt : int = int.MIN_VALUE;

		/**
		* The calculated average rank. rank = totalRank / votes
		* 
		**/
		public var rank : Number = Number.NEGATIVE_INFINITY;

		/**
		* The sum of all rank values submitted to the baseEntry.anonymousRank action
		* 
		**/
		public var totalRank : int = int.MIN_VALUE;

		/**
		* A count of all requests made to the baseEntry.anonymousRank action
		* 
		**/
		public var votes : int = int.MIN_VALUE;

		/**
		**/
		public var groupId : int = int.MIN_VALUE;

		/**
		* Can be used to store various partner related data as a string
		* 
		**/
		public var partnerData : String = null;

		/**
		* Download URL for the entry
		* 
		**/
		public var downloadUrl : String = null;

		/**
		* Indexed search text for full text search
		* 
		**/
		public var searchText : String = null;

		/**
		* License type used for this entry
		* 
		* @see com.kaltura.types.KalturaLicenseType
		**/
		public var licenseType : int = int.MIN_VALUE;

		/**
		* Version of the entry data
		* 
		**/
		public var version : int = int.MIN_VALUE;

		/**
		* Thumbnail URL
		* 
		**/
		public var thumbnailUrl : String = null;

		/**
		* The Access Control ID assigned to this entry (null when not set, send -1 to remove)
		* 
		**/
		public var accessControlId : int = int.MIN_VALUE;

		/**
		* Entry scheduling start date (null when not set, send -1 to remove)
		* 
		**/
		public var startDate : int = int.MIN_VALUE;

		/**
		* Entry scheduling end date (null when not set, send -1 to remove)
		* 
		**/
		public var endDate : int = int.MIN_VALUE;

		/**
		* Entry external reference id
		* 
		**/
		public var referenceId : String = null;

		/**
		* ID of temporary entry that will replace this entry when it's approved and ready for replacement
		* 
		**/
		public var replacingEntryId : String = null;

		/**
		* ID of the entry that will be replaced when the replacement approved and this entry is ready
		* 
		**/
		public var replacedEntryId : String = null;

		/**
		* Status of the replacement readiness and approval
		* 
		* @see com.kaltura.types.KalturaEntryReplacementStatus
		**/
		public var replacementStatus : String = null;

		/**
		* Can be used to store various partner related data as a numeric value
		* 
		**/
		public var partnerSortValue : int = int.MIN_VALUE;

		/**
		* Override the default ingestion profile
		* 
		**/
		public var conversionProfileId : int = int.MIN_VALUE;

		/**
		* IF not empty, points to an entry ID the should replace this current entry's id.
		* 
		**/
		public var redirectEntryId : String = null;

		/**
		* ID of source root entry, used for clipped, skipped and cropped entries that created from another entry
		* 
		**/
		public var rootEntryId : String = null;

		/**
		* clipping, skipping and cropping attributes that used to create this entry
		* 
		**/
		public var operationAttributes : Array = null;

		/**
		* list of user ids that are entitled to edit the entry (no server enforcement) The difference between entitledUsersEdit and entitledUsersPublish is applicative only
		* 
		**/
		public var entitledUsersEdit : String = null;

		/**
		* list of user ids that are entitled to publish the entry (no server enforcement) The difference between entitledUsersEdit and entitledUsersPublish is applicative only
		* 
		**/
		public var entitledUsersPublish : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		**/ 
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
			arr.push('redirectEntryId');
			arr.push('operationAttributes');
			arr.push('entitledUsersEdit');
			arr.push('entitledUsersPublish');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		**/ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('creatorId');
			arr.push('thumbnailUrl');
			return arr;
		}

		/** 
		* get the expected type of array elements 
		* @param arrayName 	 name of an attribute of type array of the current object 
		* @return 	 un-qualified class name 
		**/ 
		public function getElementType(arrayName:String):String
		{
			var result:String = '';
			switch (arrayName) {
				case 'operationAttributes':
					result = 'KalturaOperationAttributes';
					break;
			}
			return result;
		}
		// required for backwards compatibility with an old, un-optimized client
		public function getParamKeys():Array { trace('backward incompatible'); throw new Error('backward incompatible');}
	}
}
