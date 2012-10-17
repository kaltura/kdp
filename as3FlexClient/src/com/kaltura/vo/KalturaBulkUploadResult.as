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
	public dynamic class KalturaBulkUploadResult extends BaseFlexVo
	{
		/**
		 * The id of the result
		 * 
		 **/
		public var id : int = int.MIN_VALUE;

		/**
		 * The id of the parent job
		 * 
		 **/
		public var bulkUploadJobId : int = int.MIN_VALUE;

		/**
		 * The index of the line in the CSV
		 * 
		 **/
		public var lineIndex : int = int.MIN_VALUE;

		/**
		 **/
		public var partnerId : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaBulkUploadResultStatus
		 **/
		public var status : String = null;

		/**
		 * @see com.kaltura.types.KalturaBulkUploadAction
		 **/
		public var action : String = null;

		/**
		 **/
		public var objectId : String = null;

		/**
		 **/
		public var objectStatus : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaBulkUploadResultObjectType
		 **/
		public var bulkUploadResultObjectType : String = null;

		/**
		 * The data as recieved in the csv
		 * 
		 **/
		public var rowData : String = null;

		/**
		 **/
		public var partnerData : String = null;

		/**
		 **/
		public var objectErrorDescription : String = null;

		/**
		 **/
		public var pluginsData : Array = null;

		/**
		 **/
		public var errorDescription : String = null;

		/**
		 **/
		public var errorCode : String = null;

		/**
		 **/
		public var errorType : int = int.MIN_VALUE;

		/** 
		 * a list of attributes which may be updated on this object 
		 **/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('bulkUploadJobId');
			arr.push('lineIndex');
			arr.push('partnerId');
			arr.push('status');
			arr.push('action');
			arr.push('objectId');
			arr.push('objectStatus');
			arr.push('bulkUploadResultObjectType');
			arr.push('rowData');
			arr.push('partnerData');
			arr.push('objectErrorDescription');
			arr.push('pluginsData');
			arr.push('errorDescription');
			arr.push('errorCode');
			arr.push('errorType');
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
