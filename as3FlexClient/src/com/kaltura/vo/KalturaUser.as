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
	public dynamic class KalturaUser extends BaseFlexVo
	{
		/**
		 **/
		public var id : String = null;

		/**
		 **/
		public var partnerId : int = int.MIN_VALUE;

		/**
		 **/
		public var screenName : String = null;

		/**
		 **/
		public var fullName : String = null;

		/**
		 **/
		public var email : String = null;

		/**
		 **/
		public var dateOfBirth : int = int.MIN_VALUE;

		/**
		 **/
		public var country : String = null;

		/**
		 **/
		public var state : String = null;

		/**
		 **/
		public var city : String = null;

		/**
		 **/
		public var zip : String = null;

		/**
		 **/
		public var thumbnailUrl : String = null;

		/**
		 **/
		public var description : String = null;

		/**
		 **/
		public var tags : String = null;

		/**
		 * Admin tags can be updated only by using an admin session
		 * 
		 **/
		public var adminTags : String = null;

		/**
		 * @see com.kaltura.types.KalturaGender
		 **/
		public var gender : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaUserStatus
		 **/
		public var status : int = int.MIN_VALUE;

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
		 * Can be used to store various partner related data as a string
		 * 
		 **/
		public var partnerData : String = null;

		/**
		 **/
		public var indexedPartnerDataInt : int = int.MIN_VALUE;

		/**
		 **/
		public var indexedPartnerDataString : String = null;

		/**
		 **/
		public var storageSize : int = int.MIN_VALUE;

		/**
		 **/
		public var password : String = null;

		/**
		 **/
		public var firstName : String = null;

		/**
		 **/
		public var lastName : String = null;

		/**
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var isAdmin : Boolean;

		/**
		 **/
		public var lastLoginTime : int = int.MIN_VALUE;

		/**
		 **/
		public var statusUpdatedAt : int = int.MIN_VALUE;

		/**
		 **/
		public var deletedAt : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var loginEnabled : Boolean;

		/**
		 **/
		public var roleIds : String = null;

		/**
		 **/
		public var roleNames : String = null;

		/**
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var isAccountOwner : Boolean;

		/**
		 **/
		public var allowedPartnerIds : String = null;

		/**
		 **/
		public var allowedPartnerPackages : String = null;

		/** 
		 * a list of attributes which may be updated on this object 
		 **/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('id');
			arr.push('screenName');
			arr.push('fullName');
			arr.push('email');
			arr.push('dateOfBirth');
			arr.push('country');
			arr.push('state');
			arr.push('city');
			arr.push('zip');
			arr.push('thumbnailUrl');
			arr.push('description');
			arr.push('tags');
			arr.push('adminTags');
			arr.push('gender');
			arr.push('status');
			arr.push('partnerData');
			arr.push('indexedPartnerDataInt');
			arr.push('indexedPartnerDataString');
			arr.push('firstName');
			arr.push('lastName');
			arr.push('isAdmin');
			arr.push('roleIds');
			arr.push('allowedPartnerIds');
			arr.push('allowedPartnerPackages');
			return arr;
		}

		/** 
		 * a list of attributes which may only be inserted when initializing this object 
		 **/ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('password');
			return arr;
		}
	}
}
