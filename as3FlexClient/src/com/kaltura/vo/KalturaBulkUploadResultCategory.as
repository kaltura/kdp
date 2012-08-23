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
	public dynamic class KalturaBulkUploadResultCategory extends KalturaBulkUploadResult
	{
		/**
		 **/
		public var relativePath : String = null;

		/**
		 **/
		public var name : String = null;

		/**
		 **/
		public var referenceId : String = null;

		/**
		 **/
		public var description : String = null;

		/**
		 **/
		public var tags : String = null;

		/**
		 **/
		public var appearInList : int = int.MIN_VALUE;

		/**
		 **/
		public var privacy : int = int.MIN_VALUE;

		/**
		 **/
		public var inheritanceType : int = int.MIN_VALUE;

		/**
		 **/
		public var userJoinPolicy : int = int.MIN_VALUE;

		/**
		 **/
		public var defaultPermissionLevel : int = int.MIN_VALUE;

		/**
		 **/
		public var owner : String = null;

		/**
		 **/
		public var contributionPolicy : int = int.MIN_VALUE;

		/**
		 **/
		public var partnerSortValue : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var moderation : Boolean;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('relativePath');
			arr.push('name');
			arr.push('referenceId');
			arr.push('description');
			arr.push('tags');
			arr.push('appearInList');
			arr.push('privacy');
			arr.push('inheritanceType');
			arr.push('userJoinPolicy');
			arr.push('defaultPermissionLevel');
			arr.push('owner');
			arr.push('contributionPolicy');
			arr.push('partnerSortValue');
			arr.push('moderation');
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
