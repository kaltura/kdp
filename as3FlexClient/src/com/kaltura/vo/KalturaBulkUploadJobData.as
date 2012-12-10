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
	import com.kaltura.vo.KalturaBulkUploadObjectData;

	import com.kaltura.vo.KalturaJobData;

	[Bindable]
	public dynamic class KalturaBulkUploadJobData extends KalturaJobData
	{
		/**
		 **/
		public var userId : String = null;

		/**
		 * The screen name of the user
		 * 
		 **/
		public var uploadedBy : String = null;

		/**
		 * Selected profile id for all bulk entries
		 * 
		 **/
		public var conversionProfileId : int = int.MIN_VALUE;

		/**
		 * Created by the API
		 * 
		 **/
		public var resultsFileLocalPath : String = null;

		/**
		 * Created by the API
		 * 
		 **/
		public var resultsFileUrl : String = null;

		/**
		 * Number of created entries
		 * 
		 **/
		public var numOfEntries : int = int.MIN_VALUE;

		/**
		 * Number of created objects
		 * 
		 **/
		public var numOfObjects : int = int.MIN_VALUE;

		/**
		 * The bulk upload file path
		 * 
		 **/
		public var filePath : String = null;

		/**
		 * Type of object for bulk upload
		 * 
		 * @see com.kaltura.types.KalturaBulkUploadObjectType
		 **/
		public var bulkUploadObjectType : String = null;

		/**
		 * Friendly name of the file, used to be recognized later in the logs.
		 * 
		 **/
		public var fileName : String = null;

		/**
		 * Data pertaining to the objects being uploaded
		 * 
		 **/
		public var objectData : KalturaBulkUploadObjectData;

		/**
		 * Type of bulk upload
		 * 
		 * @see com.kaltura.types.KalturaBulkUploadType
		 **/
		public var type : String = null;

		/**
		 * Recipients of the email for bulk upload success/failure
		 * 
		 **/
		public var emailRecipients : String = null;

		/**
		 * Number of objects that finished on error status
		 * 
		 **/
		public var numOfErrorObjects : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('fileName');
			arr.push('emailRecipients');
			arr.push('numOfErrorObjects');
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
