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
	import com.kaltura.vo.KalturaCuePointFilter;

	[Bindable]
	public dynamic class KalturaCodeCuePointBaseFilter extends KalturaCuePointFilter
	{
		/**
		 **/
		public var codeLike : String = null;

		/**
		 **/
		public var codeMultiLikeOr : String = null;

		/**
		 **/
		public var codeMultiLikeAnd : String = null;

		/**
		 **/
		public var codeEqual : String = null;

		/**
		 **/
		public var codeIn : String = null;

		/**
		 **/
		public var descriptionLike : String = null;

		/**
		 **/
		public var descriptionMultiLikeOr : String = null;

		/**
		 **/
		public var descriptionMultiLikeAnd : String = null;

		/**
		 **/
		public var endTimeGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var endTimeLessThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var durationGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var durationLessThanOrEqual : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('codeLike');
			arr.push('codeMultiLikeOr');
			arr.push('codeMultiLikeAnd');
			arr.push('codeEqual');
			arr.push('codeIn');
			arr.push('descriptionLike');
			arr.push('descriptionMultiLikeOr');
			arr.push('descriptionMultiLikeAnd');
			arr.push('endTimeGreaterThanOrEqual');
			arr.push('endTimeLessThanOrEqual');
			arr.push('durationGreaterThanOrEqual');
			arr.push('durationLessThanOrEqual');
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
