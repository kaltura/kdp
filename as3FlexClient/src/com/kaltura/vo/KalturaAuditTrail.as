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
	import com.kaltura.vo.KalturaAuditTrailInfo;

	import com.kaltura.vo.BaseFlexVo;

	[Bindable]
	public dynamic class KalturaAuditTrail extends BaseFlexVo
	{
		/**
		 **/
		public var id : int = int.MIN_VALUE;

		/**
		 **/
		public var createdAt : int = int.MIN_VALUE;

		/**
		 * Indicates when the data was parsed
		 * 
		 **/
		public var parsedAt : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaAuditTrailStatus
		 **/
		public var status : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaAuditTrailObjectType
		 **/
		public var auditObjectType : String = null;

		/**
		 **/
		public var objectId : String = null;

		/**
		 **/
		public var relatedObjectId : String = null;

		/**
		 * @see com.kaltura.types.KalturaAuditTrailObjectType
		 **/
		public var relatedObjectType : String = null;

		/**
		 **/
		public var entryId : String = null;

		/**
		 **/
		public var masterPartnerId : int = int.MIN_VALUE;

		/**
		 **/
		public var partnerId : int = int.MIN_VALUE;

		/**
		 **/
		public var requestId : String = null;

		/**
		 **/
		public var userId : String = null;

		/**
		 * @see com.kaltura.types.KalturaAuditTrailAction
		 **/
		public var action : String = null;

		/**
		 **/
		public var data : KalturaAuditTrailInfo;

		/**
		 **/
		public var ks : String = null;

		/**
		 * @see com.kaltura.types.KalturaAuditTrailContext
		 **/
		public var context : int = int.MIN_VALUE;

		/**
		 * The API service and action that called and caused this audit
		 * 
		 **/
		public var entryPoint : String = null;

		/**
		 **/
		public var serverName : String = null;

		/**
		 **/
		public var ipAddress : String = null;

		/**
		 **/
		public var userAgent : String = null;

		/**
		 **/
		public var clientTag : String = null;

		/**
		 **/
		public var description : String = null;

		/**
		 **/
		public var errorDescription : String = null;

		/** 
		 * a list of attributes which may be updated on this object 
		 **/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('auditObjectType');
			arr.push('objectId');
			arr.push('relatedObjectId');
			arr.push('relatedObjectType');
			arr.push('entryId');
			arr.push('userId');
			arr.push('action');
			arr.push('data');
			arr.push('clientTag');
			arr.push('description');
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
