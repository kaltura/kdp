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
	public dynamic class KalturaBulkUploadBaseFilter extends KalturaFilter
	{
		/**
		 **/
		public var uploadedOnGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var uploadedOnLessThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var uploadedOnEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var statusIn : String = null;

		/**
		 * @see com.kaltura.types.KalturaBatchJobStatus
		 **/
		public var statusEqual : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaBulkUploadObjectType
		 **/
		public var bulkUploadObjectTypeEqual : String = null;

		/**
		 **/
		public var bulkUploadObjectTypeIn : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('uploadedOnGreaterThanOrEqual');
			arr.push('uploadedOnLessThanOrEqual');
			arr.push('uploadedOnEqual');
			arr.push('statusIn');
			arr.push('statusEqual');
			arr.push('bulkUploadObjectTypeEqual');
			arr.push('bulkUploadObjectTypeIn');
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
