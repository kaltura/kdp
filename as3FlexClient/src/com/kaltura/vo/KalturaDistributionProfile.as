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
	public dynamic class KalturaDistributionProfile extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var id : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var updatedAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var providerType : String = null;

		/** 
		* 		* */ 
		public var name : String = null;

		/** 
		* 		* */ 
		public var status : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var submitEnabled : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var updateEnabled : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var deleteEnabled : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var reportEnabled : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var autoCreateFlavors : String = null;

		/** 
		* 		* */ 
		public var autoCreateThumb : String = null;

		/** 
		* 		* */ 
		public var optionalFlavorParamsIds : String = null;

		/** 
		* 		* */ 
		public var requiredFlavorParamsIds : String = null;

		/** 
		* 		* */ 
		public var optionalThumbDimensions : Array = null;

		/** 
		* 		* */ 
		public var requiredThumbDimensions : Array = null;

		/** 
		* 		* */ 
		public var sunriseDefaultOffset : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var sunsetDefaultOffset : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var recommendedStorageProfileForDownload : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var recommendedDcForDownload : int = int.MIN_VALUE;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('status');
			arr.push('submitEnabled');
			arr.push('updateEnabled');
			arr.push('deleteEnabled');
			arr.push('reportEnabled');
			arr.push('autoCreateFlavors');
			arr.push('autoCreateThumb');
			arr.push('optionalFlavorParamsIds');
			arr.push('requiredFlavorParamsIds');
			arr.push('optionalThumbDimensions');
			arr.push('requiredThumbDimensions');
			arr.push('sunriseDefaultOffset');
			arr.push('sunsetDefaultOffset');
			arr.push('recommendedStorageProfileForDownload');
			arr.push('recommendedDcForDownload');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		* */ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('providerType');
			return arr;
		}

	}
}
