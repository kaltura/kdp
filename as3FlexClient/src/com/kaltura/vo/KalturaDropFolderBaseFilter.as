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
	public dynamic class KalturaDropFolderBaseFilter extends KalturaFilter
	{
		/** 
		* 		* */ 
		public var idEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var idIn : String = null;

		/** 
		* 		* */ 
		public var partnerIdEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerIdIn : String = null;

		/** 
		* 		* */ 
		public var nameLike : String = null;

		/** 
		* 		* */ 
		public var typeEqual : String = null;

		/** 
		* 		* */ 
		public var typeIn : String = null;

		/** 
		* 		* */ 
		public var statusEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var statusIn : String = null;

		/** 
		* 		* */ 
		public var conversionProfileIdEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var conversionProfileIdIn : String = null;

		/** 
		* 		* */ 
		public var dcEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var dcIn : String = null;

		/** 
		* 		* */ 
		public var pathLike : String = null;

		/** 
		* 		* */ 
		public var fileHandlerTypeEqual : String = null;

		/** 
		* 		* */ 
		public var fileHandlerTypeIn : String = null;

		/** 
		* 		* */ 
		public var fileNamePatternsLike : String = null;

		/** 
		* 		* */ 
		public var fileNamePatternsMultiLikeOr : String = null;

		/** 
		* 		* */ 
		public var fileNamePatternsMultiLikeAnd : String = null;

		/** 
		* 		* */ 
		public var tagsLike : String = null;

		/** 
		* 		* */ 
		public var tagsMultiLikeOr : String = null;

		/** 
		* 		* */ 
		public var tagsMultiLikeAnd : String = null;

		/** 
		* 		* */ 
		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var updatedAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var updatedAtLessThanOrEqual : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('partnerIdEqual');
			arr.push('partnerIdIn');
			arr.push('nameLike');
			arr.push('typeEqual');
			arr.push('typeIn');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('conversionProfileIdEqual');
			arr.push('conversionProfileIdIn');
			arr.push('dcEqual');
			arr.push('dcIn');
			arr.push('pathLike');
			arr.push('fileHandlerTypeEqual');
			arr.push('fileHandlerTypeIn');
			arr.push('fileNamePatternsLike');
			arr.push('fileNamePatternsMultiLikeOr');
			arr.push('fileNamePatternsMultiLikeAnd');
			arr.push('tagsLike');
			arr.push('tagsMultiLikeOr');
			arr.push('tagsMultiLikeAnd');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('updatedAtGreaterThanOrEqual');
			arr.push('updatedAtLessThanOrEqual');
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
