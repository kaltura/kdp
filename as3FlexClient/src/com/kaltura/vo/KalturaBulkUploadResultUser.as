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
	import com.kaltura.vo.KalturaBulkUploadResult;

	[Bindable]
	public dynamic class KalturaBulkUploadResultUser extends KalturaBulkUploadResult
	{
		/**
		 **/
		public var userId : String = null;

		/**
		 **/
		public var screenName : String = null;

		/**
		 **/
		public var email : String = null;

		/**
		 **/
		public var description : String = null;

		/**
		 **/
		public var tags : String = null;

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
		public var gender : int = int.MIN_VALUE;

		/**
		 **/
		public var firstName : String = null;

		/**
		 **/
		public var lastName : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('userId');
			arr.push('screenName');
			arr.push('email');
			arr.push('description');
			arr.push('tags');
			arr.push('dateOfBirth');
			arr.push('country');
			arr.push('state');
			arr.push('city');
			arr.push('zip');
			arr.push('gender');
			arr.push('firstName');
			arr.push('lastName');
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
