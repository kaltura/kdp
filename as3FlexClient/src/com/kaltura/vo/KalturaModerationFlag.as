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
	public dynamic class KalturaModerationFlag extends BaseFlexVo
	{
		/**
		 * Moderation flag id
		 * 
		 **/
		public var id : int = int.MIN_VALUE;

		/**
		 **/
		public var partnerId : int = int.MIN_VALUE;

		/**
		 * The user id that added the moderation flag
		 * 
		 **/
		public var userId : String = null;

		/**
		 * The type of the moderation flag (entry or user)
		 * 
		 * @see com.kaltura.types.KalturaModerationObjectType
		 **/
		public var moderationObjectType : String = null;

		/**
		 * If moderation flag is set for entry, this is the flagged entry id
		 * 
		 **/
		public var flaggedEntryId : String = null;

		/**
		 * If moderation flag is set for user, this is the flagged user id
		 * 
		 **/
		public var flaggedUserId : String = null;

		/**
		 * The moderation flag status
		 * 
		 * @see com.kaltura.types.KalturaModerationFlagStatus
		 **/
		public var status : String = null;

		/**
		 * The comment that was added to the flag
		 * 
		 **/
		public var comments : String = null;

		/**
		 * @see com.kaltura.types.KalturaModerationFlagType
		 **/
		public var flagType : int = int.MIN_VALUE;

		/**
		 **/
		public var createdAt : int = int.MIN_VALUE;

		/**
		 **/
		public var updatedAt : int = int.MIN_VALUE;

		/** 
		 * a list of attributes which may be updated on this object 
		 **/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('flaggedEntryId');
			arr.push('flaggedUserId');
			arr.push('comments');
			arr.push('flagType');
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
