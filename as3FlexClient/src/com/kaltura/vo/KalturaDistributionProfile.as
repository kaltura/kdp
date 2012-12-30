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
		 * Auto generated unique id
		 * 
		 **/
		public var id : int = int.MIN_VALUE;

		/**
		 * Profile creation date as Unix timestamp (In seconds)
		 * 
		 **/
		public var createdAt : int = int.MIN_VALUE;

		/**
		 * Profile last update date as Unix timestamp (In seconds)
		 * 
		 **/
		public var updatedAt : int = int.MIN_VALUE;

		/**
		 **/
		public var partnerId : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaDistributionProviderType
		 **/
		public var providerType : String = null;

		/**
		 **/
		public var name : String = null;

		/**
		 * @see com.kaltura.types.KalturaDistributionProfileStatus
		 **/
		public var status : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaDistributionProfileActionStatus
		 **/
		public var submitEnabled : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaDistributionProfileActionStatus
		 **/
		public var updateEnabled : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaDistributionProfileActionStatus
		 **/
		public var deleteEnabled : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaDistributionProfileActionStatus
		 **/
		public var reportEnabled : int = int.MIN_VALUE;

		/**
		 * Comma separated flavor params ids that should be auto converted
		 * 
		 **/
		public var autoCreateFlavors : String = null;

		/**
		 * Comma separated thumbnail params ids that should be auto generated
		 * 
		 **/
		public var autoCreateThumb : String = null;

		/**
		 * Comma separated flavor params ids that should be submitted if ready
		 * 
		 **/
		public var optionalFlavorParamsIds : String = null;

		/**
		 * Comma separated flavor params ids that required to be ready before submission
		 * 
		 **/
		public var requiredFlavorParamsIds : String = null;

		/**
		 * Thumbnail dimensions that should be submitted if ready
		 * 
		 **/
		public var optionalThumbDimensions : Array = null;

		/**
		 * Thumbnail dimensions that required to be readt before submission
		 * 
		 **/
		public var requiredThumbDimensions : Array = null;

		/**
		 * Asset Distribution Rules for assets that should be submitted if ready
		 * 
		 **/
		public var optionalAssetDistributionRules : Array = null;

		/**
		 * Assets Asset Distribution Rules for assets that are required to be ready before submission
		 * 
		 **/
		public var requiredAssetDistributionRules : Array = null;

		/**
		 * If entry distribution sunrise not specified that will be the default since entry creation time, in seconds
		 * 
		 **/
		public var sunriseDefaultOffset : int = int.MIN_VALUE;

		/**
		 * If entry distribution sunset not specified that will be the default since entry creation time, in seconds
		 * 
		 **/
		public var sunsetDefaultOffset : int = int.MIN_VALUE;

		/**
		 * The best external storage to be used to download the asset files from
		 * 
		 **/
		public var recommendedStorageProfileForDownload : int = int.MIN_VALUE;

		/**
		 * The best Kaltura data center to be used to download the asset files to
		 * 
		 **/
		public var recommendedDcForDownload : int = int.MIN_VALUE;

		/**
		 * The best Kaltura data center to be used to execute the distribution job
		 * 
		 **/
		public var recommendedDcForExecute : int = int.MIN_VALUE;

		/** 
		 * a list of attributes which may be updated on this object 
		 **/ 
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
			arr.push('optionalAssetDistributionRules');
			arr.push('requiredAssetDistributionRules');
			arr.push('sunriseDefaultOffset');
			arr.push('sunsetDefaultOffset');
			arr.push('recommendedStorageProfileForDownload');
			arr.push('recommendedDcForDownload');
			arr.push('recommendedDcForExecute');
			return arr;
		}

		/** 
		 * a list of attributes which may only be inserted when initializing this object 
		 **/ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('providerType');
			return arr;
		}
	}
}
