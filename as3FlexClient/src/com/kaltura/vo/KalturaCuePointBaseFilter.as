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
	public dynamic class KalturaCuePointBaseFilter extends KalturaFilter
	{
		/**
		 **/
		public var idEqual : String = null;

		/**
		 **/
		public var idIn : String = null;

		/**
		 * @see com.kaltura.types.KalturaCuePointType
		 **/
		public var cuePointTypeEqual : String = null;

		/**
		 **/
		public var cuePointTypeIn : String = null;

		/**
		 * @see com.kaltura.types.KalturaCuePointStatus
		 **/
		public var statusEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var statusIn : String = null;

		/**
		 **/
		public var entryIdEqual : String = null;

		/**
		 **/
		public var entryIdIn : String = null;

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
		public var tagsLike : String = null;

		/**
		 **/
		public var tagsMultiLikeOr : String = null;

		/**
		 **/
		public var tagsMultiLikeAnd : String = null;

		/**
		 **/
		public var startTimeGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var startTimeLessThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var userIdEqual : String = null;

		/**
		 **/
		public var userIdIn : String = null;

		/**
		 **/
		public var partnerSortValueEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var partnerSortValueIn : String = null;

		/**
		 **/
		public var partnerSortValueGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var partnerSortValueLessThanOrEqual : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaNullableBoolean
		 **/
		public var forceStopEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var systemNameEqual : String = null;

		/**
		 **/
		public var systemNameIn : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('cuePointTypeEqual');
			arr.push('cuePointTypeIn');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('entryIdEqual');
			arr.push('entryIdIn');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('updatedAtGreaterThanOrEqual');
			arr.push('updatedAtLessThanOrEqual');
			arr.push('tagsLike');
			arr.push('tagsMultiLikeOr');
			arr.push('tagsMultiLikeAnd');
			arr.push('startTimeGreaterThanOrEqual');
			arr.push('startTimeLessThanOrEqual');
			arr.push('userIdEqual');
			arr.push('userIdIn');
			arr.push('partnerSortValueEqual');
			arr.push('partnerSortValueIn');
			arr.push('partnerSortValueGreaterThanOrEqual');
			arr.push('partnerSortValueLessThanOrEqual');
			arr.push('forceStopEqual');
			arr.push('systemNameEqual');
			arr.push('systemNameIn');
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
