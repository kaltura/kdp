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
	public dynamic class KalturaEmailIngestionProfile extends BaseFlexVo
	{
		/**
		 **/
		public var id : int = int.MIN_VALUE;

		/**
		 **/
		public var name : String = null;

		/**
		 **/
		public var description : String = null;

		/**
		 **/
		public var emailAddress : String = null;

		/**
		 **/
		public var mailboxId : String = null;

		/**
		 **/
		public var partnerId : int = int.MIN_VALUE;

		/**
		 **/
		public var conversionProfile2Id : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaEntryModerationStatus
		 **/
		public var moderationStatus : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaEmailIngestionProfileStatus
		 **/
		public var status : int = int.MIN_VALUE;

		/**
		 **/
		public var createdAt : String = null;

		/**
		 **/
		public var defaultCategory : String = null;

		/**
		 **/
		public var defaultUserId : String = null;

		/**
		 **/
		public var defaultTags : String = null;

		/**
		 **/
		public var defaultAdminTags : String = null;

		/**
		 **/
		public var maxAttachmentSizeKbytes : int = int.MIN_VALUE;

		/**
		 **/
		public var maxAttachmentsPerMail : int = int.MIN_VALUE;

		/** 
		 * a list of attributes which may be updated on this object 
		 **/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('description');
			arr.push('emailAddress');
			arr.push('mailboxId');
			arr.push('conversionProfile2Id');
			arr.push('moderationStatus');
			arr.push('defaultCategory');
			arr.push('defaultUserId');
			arr.push('defaultTags');
			arr.push('defaultAdminTags');
			arr.push('maxAttachmentSizeKbytes');
			arr.push('maxAttachmentsPerMail');
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
