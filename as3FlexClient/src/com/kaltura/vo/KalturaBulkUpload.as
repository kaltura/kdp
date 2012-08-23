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
	public dynamic class KalturaBulkUpload extends BaseFlexVo
	{
		/**
		 **/
		public var id : int = int.MIN_VALUE;

		/**
		 **/
		public var uploadedBy : String = null;

		/**
		 **/
		public var uploadedByUserId : String = null;

		/**
		 **/
		public var uploadedOn : int = int.MIN_VALUE;

		/**
		 **/
		public var numOfEntries : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaBatchJobStatus
		 **/
		public var status : int = int.MIN_VALUE;

		/**
		 **/
		public var logFileUrl : String = null;

		/**
		 **/
		public var csvFileUrl : String = null;

		/**
		 **/
		public var bulkFileUrl : String = null;

		/**
		 * @see com.kaltura.types.KalturaBulkUploadType
		 **/
		public var bulkUploadType : String = null;

		/**
		 **/
		public var results : Array = null;

		/**
		 **/
		public var error : String = null;

		/**
		 * @see com.kaltura.types.KalturaBatchJobErrorTypes
		 **/
		public var errorType : int = int.MIN_VALUE;

		/**
		 **/
		public var errorNumber : int = int.MIN_VALUE;

		/**
		 **/
		public var fileName : String = null;

		/**
		 **/
		public var description : String = null;

		/**
		 **/
		public var numOfObjects : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaBulkUploadObjectType
		 **/
		public var bulkUploadObjectType : String = null;

		/** 
		 * a list of attributes which may be updated on this object 
		 **/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('id');
			arr.push('uploadedBy');
			arr.push('uploadedByUserId');
			arr.push('uploadedOn');
			arr.push('numOfEntries');
			arr.push('status');
			arr.push('logFileUrl');
			arr.push('csvFileUrl');
			arr.push('bulkFileUrl');
			arr.push('bulkUploadType');
			arr.push('results');
			arr.push('error');
			arr.push('errorType');
			arr.push('errorNumber');
			arr.push('fileName');
			arr.push('description');
			arr.push('numOfObjects');
			arr.push('bulkUploadObjectType');
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
