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
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaAuditTrailBaseFilter extends KalturaFilter
	{
		/**
		 **/
		public var idEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var parsedAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var parsedAtLessThanOrEqual : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaAuditTrailStatus
		 **/
		public var statusEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var statusIn : String = null;

		/**
		 * @see com.kaltura.types.KalturaAuditTrailObjectType
		 **/
		public var auditObjectTypeEqual : String = null;

		/**
		 **/
		public var auditObjectTypeIn : String = null;

		/**
		 **/
		public var objectIdEqual : String = null;

		/**
		 **/
		public var objectIdIn : String = null;

		/**
		 **/
		public var relatedObjectIdEqual : String = null;

		/**
		 **/
		public var relatedObjectIdIn : String = null;

		/**
		 * @see com.kaltura.types.KalturaAuditTrailObjectType
		 **/
		public var relatedObjectTypeEqual : String = null;

		/**
		 **/
		public var relatedObjectTypeIn : String = null;

		/**
		 **/
		public var entryIdEqual : String = null;

		/**
		 **/
		public var entryIdIn : String = null;

		/**
		 **/
		public var masterPartnerIdEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var masterPartnerIdIn : String = null;

		/**
		 **/
		public var partnerIdEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var partnerIdIn : String = null;

		/**
		 **/
		public var requestIdEqual : String = null;

		/**
		 **/
		public var requestIdIn : String = null;

		/**
		 **/
		public var userIdEqual : String = null;

		/**
		 **/
		public var userIdIn : String = null;

		/**
		 * @see com.kaltura.types.KalturaAuditTrailAction
		 **/
		public var actionEqual : String = null;

		/**
		 **/
		public var actionIn : String = null;

		/**
		 **/
		public var ksEqual : String = null;

		/**
		 * @see com.kaltura.types.KalturaAuditTrailContext
		 **/
		public var contextEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var contextIn : String = null;

		/**
		 **/
		public var entryPointEqual : String = null;

		/**
		 **/
		public var entryPointIn : String = null;

		/**
		 **/
		public var serverNameEqual : String = null;

		/**
		 **/
		public var serverNameIn : String = null;

		/**
		 **/
		public var ipAddressEqual : String = null;

		/**
		 **/
		public var ipAddressIn : String = null;

		/**
		 **/
		public var clientTagEqual : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('parsedAtGreaterThanOrEqual');
			arr.push('parsedAtLessThanOrEqual');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('auditObjectTypeEqual');
			arr.push('auditObjectTypeIn');
			arr.push('objectIdEqual');
			arr.push('objectIdIn');
			arr.push('relatedObjectIdEqual');
			arr.push('relatedObjectIdIn');
			arr.push('relatedObjectTypeEqual');
			arr.push('relatedObjectTypeIn');
			arr.push('entryIdEqual');
			arr.push('entryIdIn');
			arr.push('masterPartnerIdEqual');
			arr.push('masterPartnerIdIn');
			arr.push('partnerIdEqual');
			arr.push('partnerIdIn');
			arr.push('requestIdEqual');
			arr.push('requestIdIn');
			arr.push('userIdEqual');
			arr.push('userIdIn');
			arr.push('actionEqual');
			arr.push('actionIn');
			arr.push('ksEqual');
			arr.push('contextEqual');
			arr.push('contextIn');
			arr.push('entryPointEqual');
			arr.push('entryPointIn');
			arr.push('serverNameEqual');
			arr.push('serverNameIn');
			arr.push('ipAddressEqual');
			arr.push('ipAddressIn');
			arr.push('clientTagEqual');
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
