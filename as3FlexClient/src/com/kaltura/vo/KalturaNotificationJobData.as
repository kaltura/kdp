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
	import com.kaltura.vo.KalturaJobData;

	[Bindable]
	public dynamic class KalturaNotificationJobData extends KalturaJobData
	{
		/**
		 **/
		public var userId : String = null;

		/**
		 * @see com.kaltura.types.KalturaNotificationType
		 **/
		public var type : int = int.MIN_VALUE;

		/**
		 **/
		public var typeAsString : String = null;

		/**
		 **/
		public var objectId : String = null;

		/**
		 * @see com.kaltura.types.KalturaNotificationStatus
		 **/
		public var status : int = int.MIN_VALUE;

		/**
		 **/
		public var data : String = null;

		/**
		 **/
		public var numberOfAttempts : int = int.MIN_VALUE;

		/**
		 **/
		public var notificationResult : String = null;

		/**
		 * @see com.kaltura.types.KalturaNotificationObjectType
		 **/
		public var objType : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('userId');
			arr.push('type');
			arr.push('typeAsString');
			arr.push('objectId');
			arr.push('status');
			arr.push('data');
			arr.push('numberOfAttempts');
			arr.push('notificationResult');
			arr.push('objType');
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
