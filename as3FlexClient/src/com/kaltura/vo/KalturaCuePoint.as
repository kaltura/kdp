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
	public dynamic class KalturaCuePoint extends BaseFlexVo
	{
		/**
		 **/
		public var id : String = null;

		/**
		 * @see com.kaltura.types.KalturaCuePointType
		 **/
		public var cuePointType : String = null;

		/**
		 * @see com.kaltura.types.KalturaCuePointStatus
		 **/
		public var status : int = int.MIN_VALUE;

		/**
		 **/
		public var entryId : String = null;

		/**
		 **/
		public var partnerId : int = int.MIN_VALUE;

		/**
		 **/
		public var createdAt : int = int.MIN_VALUE;

		/**
		 **/
		public var updatedAt : int = int.MIN_VALUE;

		/**
		 **/
		public var tags : String = null;

		/**
		 * Start time in milliseconds
		 * 
		 **/
		public var startTime : int = int.MIN_VALUE;

		/**
		 **/
		public var userId : String = null;

		/**
		 **/
		public var partnerData : String = null;

		/**
		 **/
		public var partnerSortValue : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaNullableBoolean
		 **/
		public var forceStop : int = int.MIN_VALUE;

		/**
		 **/
		public var thumbOffset : int = int.MIN_VALUE;

		/**
		 **/
		public var systemName : String = null;

		/** 
		 * a list of attributes which may be updated on this object 
		 **/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('tags');
			arr.push('startTime');
			arr.push('partnerData');
			arr.push('partnerSortValue');
			arr.push('forceStop');
			arr.push('thumbOffset');
			arr.push('systemName');
			return arr;
		}

		/** 
		 * a list of attributes which may only be inserted when initializing this object 
		 **/ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('entryId');
			return arr;
		}
	}
}
