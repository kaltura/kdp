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
	public dynamic class KalturaCategoryBaseFilter extends KalturaFilter
	{
		/**
		 **/
		public var idEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var idIn : String = null;

		/**
		 **/
		public var parentIdEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var parentIdIn : String = null;

		/**
		 **/
		public var depthEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var fullNameEqual : String = null;

		/**
		 **/
		public var fullNameStartsWith : String = null;

		/**
		 **/
		public var fullNameIn : String = null;

		/**
		 **/
		public var fullIdsEqual : String = null;

		/**
		 **/
		public var fullIdsStartsWith : String = null;

		/**
		 **/
		public var fullIdsMatchOr : String = null;

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
		 **/
		public var tagsLike : String = null;

		/**
		 **/
		public var tagsMultiLikeOr : String = null;

		/**
		 **/
		public var tagsMultiLikeAnd : String = null;

		/**
		 * @see com.kaltura.types.KalturaAppearInListType
		 **/
		public var appearInListEqual : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaPrivacyType
		 **/
		public var privacyEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var privacyIn : String = null;

		/**
		 * @see com.kaltura.types.KalturaInheritanceType
		 **/
		public var inheritanceTypeEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var inheritanceTypeIn : String = null;

		/**
		 **/
		public var referenceIdEqual : String = null;

		/**
		 * @see com.kaltura.types.KalturaContributionPolicyType
		 **/
		public var contributionPolicyEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var membersCountGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var membersCountLessThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var pendingMembersCountGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var pendingMembersCountLessThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var privacyContextEqual : String = null;

		/**
		 * @see com.kaltura.types.KalturaCategoryStatus
		 **/
		public var statusEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var statusIn : String = null;

		/**
		 **/
		public var inheritedParentIdEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var inheritedParentIdIn : String = null;

		/**
		 **/
		public var partnerSortValueGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		 **/
		public var partnerSortValueLessThanOrEqual : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('parentIdEqual');
			arr.push('parentIdIn');
			arr.push('depthEqual');
			arr.push('fullNameEqual');
			arr.push('fullNameStartsWith');
			arr.push('fullNameIn');
			arr.push('fullIdsEqual');
			arr.push('fullIdsStartsWith');
			arr.push('fullIdsMatchOr');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('updatedAtGreaterThanOrEqual');
			arr.push('updatedAtLessThanOrEqual');
			arr.push('tagsLike');
			arr.push('tagsMultiLikeOr');
			arr.push('tagsMultiLikeAnd');
			arr.push('appearInListEqual');
			arr.push('privacyEqual');
			arr.push('privacyIn');
			arr.push('inheritanceTypeEqual');
			arr.push('inheritanceTypeIn');
			arr.push('referenceIdEqual');
			arr.push('contributionPolicyEqual');
			arr.push('membersCountGreaterThanOrEqual');
			arr.push('membersCountLessThanOrEqual');
			arr.push('pendingMembersCountGreaterThanOrEqual');
			arr.push('pendingMembersCountLessThanOrEqual');
			arr.push('privacyContextEqual');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('inheritedParentIdEqual');
			arr.push('inheritedParentIdIn');
			arr.push('partnerSortValueGreaterThanOrEqual');
			arr.push('partnerSortValueLessThanOrEqual');
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
