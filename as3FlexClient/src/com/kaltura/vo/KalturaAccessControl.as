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
	public dynamic class KalturaAccessControl extends BaseFlexVo
	{
		/**
		 * The id of the Access Control Profile
		 * 
		 **/
		public var id : int = int.MIN_VALUE;

		/**
		 **/
		public var partnerId : int = int.MIN_VALUE;

		/**
		 * The name of the Access Control Profile
		 * 
		 **/
		public var name : String = null;

		/**
		 * System name of the Access Control Profile
		 * 
		 **/
		public var systemName : String = null;

		/**
		 * The description of the Access Control Profile
		 * 
		 **/
		public var description : String = null;

		/**
		 * Creation date as Unix timestamp (In seconds)
		 * 
		 **/
		public var createdAt : int = int.MIN_VALUE;

		/**
		 * True if this Conversion Profile is the default
		 * 
		 * @see com.kaltura.types.KalturaNullableBoolean
		 **/
		public var isDefault : int = int.MIN_VALUE;

		/**
		 * Array of Access Control Restrictions
		 * 
		 **/
		public var restrictions : Array = null;

		/**
		 * Indicates that the access control profile is new and should be handled using KalturaAccessControlProfile object and accessControlProfile service
		 * 
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var containsUnsuportedRestrictions : Boolean;

		/** 
		 * a list of attributes which may be updated on this object 
		 **/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('systemName');
			arr.push('description');
			arr.push('isDefault');
			arr.push('restrictions');
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
