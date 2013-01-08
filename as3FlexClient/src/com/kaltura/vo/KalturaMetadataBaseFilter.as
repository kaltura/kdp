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
	public dynamic class KalturaMetadataBaseFilter extends KalturaFilter
	{
		/**
		 **/
		public var partnerIdEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var metadataProfileIdEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var metadataProfileVersionEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var metadataProfileVersionGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var metadataProfileVersionLessThanOrEqual : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaMetadataObjectType
		 **/
		public var metadataObjectTypeEqual : String = null;

		/**
		 **/
		public var objectIdEqual : String = null;

		/**
		 **/
		public var objectIdIn : String = null;

		/**
		 **/
		public var versionEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var versionGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var versionLessThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var updatedAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var updatedAtLessThanOrEqual : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaMetadataStatus
		 **/
		public var statusEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var statusIn : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('partnerIdEqual');
			arr.push('metadataProfileIdEqual');
			arr.push('metadataProfileVersionEqual');
			arr.push('metadataProfileVersionGreaterThanOrEqual');
			arr.push('metadataProfileVersionLessThanOrEqual');
			arr.push('metadataObjectTypeEqual');
			arr.push('objectIdEqual');
			arr.push('objectIdIn');
			arr.push('versionEqual');
			arr.push('versionGreaterThanOrEqual');
			arr.push('versionLessThanOrEqual');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('updatedAtGreaterThanOrEqual');
			arr.push('updatedAtLessThanOrEqual');
			arr.push('statusEqual');
			arr.push('statusIn');
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
