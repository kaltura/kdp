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
	public dynamic class KalturaFileSyncBaseFilter extends KalturaFilter
	{
		/**
		 **/
		public var partnerIdEqual : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaFileSyncObjectType
		 **/
		public var fileObjectTypeEqual : String = null;

		/**
		 **/
		public var fileObjectTypeIn : String = null;

		/**
		 **/
		public var objectIdEqual : String = null;

		/**
		 **/
		public var objectIdIn : String = null;

		/**
		 **/
		public var versionEqual : String = null;

		/**
		 **/
		public var versionIn : String = null;

		/**
		 **/
		public var objectSubTypeEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var objectSubTypeIn : String = null;

		/**
		 **/
		public var dcEqual : String = null;

		/**
		 **/
		public var dcIn : String = null;

		/**
		 **/
		public var originalEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
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
		public var readyAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var readyAtLessThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var syncTimeGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var syncTimeLessThanOrEqual : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaFileSyncStatus
		 **/
		public var statusEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var statusIn : String = null;

		/**
		 * @see com.kaltura.types.KalturaFileSyncType
		 **/
		public var fileTypeEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var fileTypeIn : String = null;

		/**
		 **/
		public var linkedIdEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var linkCountGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var linkCountLessThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var fileSizeGreaterThanOrEqual : Number = Number.NEGATIVE_INFINITY;

		/**
		 **/
		public var fileSizeLessThanOrEqual : Number = Number.NEGATIVE_INFINITY;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('partnerIdEqual');
			arr.push('fileObjectTypeEqual');
			arr.push('fileObjectTypeIn');
			arr.push('objectIdEqual');
			arr.push('objectIdIn');
			arr.push('versionEqual');
			arr.push('versionIn');
			arr.push('objectSubTypeEqual');
			arr.push('objectSubTypeIn');
			arr.push('dcEqual');
			arr.push('dcIn');
			arr.push('originalEqual');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('updatedAtGreaterThanOrEqual');
			arr.push('updatedAtLessThanOrEqual');
			arr.push('readyAtGreaterThanOrEqual');
			arr.push('readyAtLessThanOrEqual');
			arr.push('syncTimeGreaterThanOrEqual');
			arr.push('syncTimeLessThanOrEqual');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('fileTypeEqual');
			arr.push('fileTypeIn');
			arr.push('linkedIdEqual');
			arr.push('linkCountGreaterThanOrEqual');
			arr.push('linkCountLessThanOrEqual');
			arr.push('fileSizeGreaterThanOrEqual');
			arr.push('fileSizeLessThanOrEqual');
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
