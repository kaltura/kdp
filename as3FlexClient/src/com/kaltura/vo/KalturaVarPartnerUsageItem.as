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
	public dynamic class KalturaVarPartnerUsageItem extends BaseFlexVo
	{
		/**
		 * Partner ID
		 * 
		 **/
		public var partnerId : int = int.MIN_VALUE;

		/**
		 * Partner name
		 * 
		 **/
		public var partnerName : String = null;

		/**
		 * Partner status
		 * 
		 * @see com.kaltura.types.KalturaPartnerStatus
		 **/
		public var partnerStatus : int = int.MIN_VALUE;

		/**
		 * Partner package
		 * 
		 **/
		public var partnerPackage : int = int.MIN_VALUE;

		/**
		 * Partner creation date (Unix timestamp)
		 * 
		 **/
		public var partnerCreatedAt : int = int.MIN_VALUE;

		/**
		 * Number of player loads in the specific date range
		 * 
		 **/
		public var views : int = int.MIN_VALUE;

		/**
		 * Number of plays in the specific date range
		 * 
		 **/
		public var plays : int = int.MIN_VALUE;

		/**
		 * Number of new entries created during specific date range
		 * 
		 **/
		public var entriesCount : int = int.MIN_VALUE;

		/**
		 * Total number of entries
		 * 
		 **/
		public var totalEntriesCount : int = int.MIN_VALUE;

		/**
		 * Number of new video entries created during specific date range
		 * 
		 **/
		public var videoEntriesCount : int = int.MIN_VALUE;

		/**
		 * Number of new image entries created during specific date range
		 * 
		 **/
		public var imageEntriesCount : int = int.MIN_VALUE;

		/**
		 * Number of new audio entries created during specific date range
		 * 
		 **/
		public var audioEntriesCount : int = int.MIN_VALUE;

		/**
		 * Number of new mix entries created during specific date range
		 * 
		 **/
		public var mixEntriesCount : int = int.MIN_VALUE;

		/**
		 * The total bandwidth usage during the given date range (in MB)
		 * 
		 **/
		public var bandwidth : Number = Number.NEGATIVE_INFINITY;

		/**
		 * The total storage consumption (in MB)
		 * 
		 **/
		public var totalStorage : Number = Number.NEGATIVE_INFINITY;

		/**
		 * The added storage consumption (new uploads) during the given date range (in MB)
		 * 
		 **/
		public var storage : Number = Number.NEGATIVE_INFINITY;

		/**
		 * The deleted storage consumption (new uploads) during the given date range (in MB)
		 * 
		 **/
		public var deletedStorage : Number = Number.NEGATIVE_INFINITY;

		/**
		 * The peak amount of storage consumption during the given date range for the specific publisher
		 * 
		 **/
		public var peakStorage : Number = Number.NEGATIVE_INFINITY;

		/**
		 * The average amount of storage consumption during the given date range for the specific publisher
		 * 
		 **/
		public var avgStorage : Number = Number.NEGATIVE_INFINITY;

		/**
		 * The combined amount of bandwidth and storage consumed during the given date range for the specific publisher
		 * 
		 **/
		public var combinedStorageBandwidth : Number = Number.NEGATIVE_INFINITY;

		/**
		 * TGhe date at which the report was taken - Unix Timestamp
		 * 
		 **/
		public var dateId : String = null;

		/** 
		 * a list of attributes which may be updated on this object 
		 **/ 
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
			arr.push('deletedStorage');
			arr.push('peakStorage');
			arr.push('avgStorage');
			arr.push('combinedStorageBandwidth');
			arr.push('dateId');
			return arr;
		}

		/** 
		 * a list of attributes which may only be inserted when initializing this object 
		 **/ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}
	}
}
