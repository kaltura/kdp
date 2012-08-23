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
	public dynamic class KalturaUploadToken extends BaseFlexVo
	{
		/**
		 * Upload token unique ID
		 * 
		 **/
		public var id : String = null;

		/**
		 * Partner ID of the upload token
		 * 
		 **/
		public var partnerId : int = int.MIN_VALUE;

		/**
		 * User id for the upload token
		 * 
		 **/
		public var userId : String = null;

		/**
		 * Status of the upload token
		 * 
		 * @see com.kaltura.types.KalturaUploadTokenStatus
		 **/
		public var status : int = int.MIN_VALUE;

		/**
		 * Name of the file for the upload token, can be empty when the upload token is created and will be updated internally after the file is uploaded
		 * 
		 **/
		public var fileName : String = null;

		/**
		 * File size in bytes, can be empty when the upload token is created and will be updated internally after the file is uploaded
		 * 
		 **/
		public var fileSize : Number = Number.NEGATIVE_INFINITY;

		/**
		 * Uploaded file size in bytes, can be used to identify how many bytes were uploaded before resuming
		 * 
		 **/
		public var uploadedFileSize : Number = Number.NEGATIVE_INFINITY;

		/**
		 * Creation date as Unix timestamp (In seconds)
		 * 
		 **/
		public var createdAt : int = int.MIN_VALUE;

		/**
		 * Last update date as Unix timestamp (In seconds)
		 * 
		 **/
		public var updatedAt : int = int.MIN_VALUE;

		/** 
		 * a list of attributes which may be updated on this object 
		 **/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}

		/** 
		 * a list of attributes which may only be inserted when initializing this object 
		 **/ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('fileName');
			arr.push('fileSize');
			return arr;
		}
	}
}
