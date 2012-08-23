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
	public dynamic class KalturaBulkUploadResultEntry extends KalturaBulkUploadResult
	{
		/**
		 **/
		public var entryId : String = null;

		/**
		 **/
		public var title : String = null;

		/**
		 **/
		public var description : String = null;

		/**
		 **/
		public var tags : String = null;

		/**
		 **/
		public var url : String = null;

		/**
		 **/
		public var contentType : String = null;

		/**
		 **/
		public var conversionProfileId : int = int.MIN_VALUE;

		/**
		 **/
		public var accessControlProfileId : int = int.MIN_VALUE;

		/**
		 **/
		public var category : String = null;

		/**
		 **/
		public var scheduleStartDate : int = int.MIN_VALUE;

		/**
		 **/
		public var scheduleEndDate : int = int.MIN_VALUE;

		/**
		 **/
		public var entryStatus : int = int.MIN_VALUE;

		/**
		 **/
		public var thumbnailUrl : String = null;

		/**
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var thumbnailSaved : Boolean;

		/**
		 **/
		public var sshPrivateKey : String = null;

		/**
		 **/
		public var sshPublicKey : String = null;

		/**
		 **/
		public var sshKeyPassphrase : String = null;

		/**
		 **/
		public var creatorId : String = null;

		/**
		 **/
		public var entitledUsersEdit : String = null;

		/**
		 **/
		public var entitledUsersPublish : String = null;

		/**
		 **/
		public var ownerId : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('entryId');
			arr.push('title');
			arr.push('description');
			arr.push('tags');
			arr.push('url');
			arr.push('contentType');
			arr.push('conversionProfileId');
			arr.push('accessControlProfileId');
			arr.push('category');
			arr.push('scheduleStartDate');
			arr.push('scheduleEndDate');
			arr.push('entryStatus');
			arr.push('thumbnailUrl');
			arr.push('thumbnailSaved');
			arr.push('sshPrivateKey');
			arr.push('sshPublicKey');
			arr.push('sshKeyPassphrase');
			arr.push('creatorId');
			arr.push('entitledUsersEdit');
			arr.push('entitledUsersPublish');
			arr.push('ownerId');
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
