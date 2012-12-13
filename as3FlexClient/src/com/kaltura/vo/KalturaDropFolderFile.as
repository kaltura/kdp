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
	public dynamic class KalturaDropFolderFile extends BaseFlexVo
	{
		/**
		 **/
		public var id : int = int.MIN_VALUE;

		/**
		 **/
		public var partnerId : int = int.MIN_VALUE;

		/**
		 **/
		public var dropFolderId : int = int.MIN_VALUE;

		/**
		 **/
		public var fileName : String = null;

		/**
		 **/
		public var fileSize : Number = Number.NEGATIVE_INFINITY;

		/**
		 **/
		public var fileSizeLastSetAt : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaDropFolderFileStatus
		 **/
		public var status : int = int.MIN_VALUE;

		/**
		 **/
		public var parsedSlug : String = null;

		/**
		 **/
		public var parsedFlavor : String = null;

		/**
		 **/
		public var leadDropFolderFileId : int = int.MIN_VALUE;

		/**
		 **/
		public var deletedDropFolderFileId : int = int.MIN_VALUE;

		/**
		 **/
		public var entryId : String = null;

		/**
		 * @see com.kaltura.types.KalturaDropFolderFileErrorCode
		 **/
		public var errorCode : String = null;

		/**
		 **/
		public var errorDescription : String = null;

		/**
		 **/
		public var lastModificationTime : String = null;

		/**
		 **/
		public var createdAt : int = int.MIN_VALUE;

		/**
		 **/
		public var updatedAt : int = int.MIN_VALUE;

		/**
		 **/
		public var uploadStartDetectedAt : int = int.MIN_VALUE;

		/**
		 **/
		public var uploadEndDetectedAt : int = int.MIN_VALUE;

		/**
		 **/
		public var importStartedAt : int = int.MIN_VALUE;

		/**
		 **/
		public var importEndedAt : int = int.MIN_VALUE;

		/**
		 **/
		public var batchJobId : int = int.MIN_VALUE;

		/** 
		 * a list of attributes which may be updated on this object 
		 **/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('fileSize');
			arr.push('parsedSlug');
			arr.push('parsedFlavor');
			arr.push('leadDropFolderFileId');
			arr.push('deletedDropFolderFileId');
			arr.push('entryId');
			arr.push('errorCode');
			arr.push('errorDescription');
			arr.push('lastModificationTime');
			arr.push('uploadStartDetectedAt');
			arr.push('uploadEndDetectedAt');
			arr.push('importStartedAt');
			arr.push('importEndedAt');
			return arr;
		}

		/** 
		 * a list of attributes which may only be inserted when initializing this object 
		 **/ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('dropFolderId');
			arr.push('fileName');
			return arr;
		}
	}
}
