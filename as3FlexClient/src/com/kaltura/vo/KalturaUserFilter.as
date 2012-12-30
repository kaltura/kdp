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
	import com.kaltura.vo.KalturaUserBaseFilter;

	[Bindable]
	public dynamic class KalturaUserFilter extends KalturaUserBaseFilter
	{
		/**
		 **/
		public var idOrScreenNameStartsWith : String = null;

		/**
		 **/
		public var idEqual : String = null;

		/**
		 **/
		public var idIn : String = null;

		/**
		 * @see com.kaltura.types.KalturaNullableBoolean
		 **/
		public var loginEnabledEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var roleIdEqual : String = null;

		/**
		 **/
		public var roleIdsEqual : String = null;

		/**
		 **/
		public var roleIdsIn : String = null;

		/**
		 **/
		public var firstNameOrLastNameStartsWith : String = null;

		/**
		 * Permission names filter expression
		 * 
		 **/
		public var permissionNamesMultiLikeOr : String = null;

		/**
		 * Permission names filter expression
		 * 
		 **/
		public var permissionNamesMultiLikeAnd : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idOrScreenNameStartsWith');
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('loginEnabledEqual');
			arr.push('roleIdEqual');
			arr.push('roleIdsEqual');
			arr.push('roleIdsIn');
			arr.push('firstNameOrLastNameStartsWith');
			arr.push('permissionNamesMultiLikeOr');
			arr.push('permissionNamesMultiLikeAnd');
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
