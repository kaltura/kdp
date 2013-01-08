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
	public dynamic class KalturaEntryDistribution extends BaseFlexVo
	{
		/**
		 * Auto generated unique id
		 * 
		 **/
		public var id : int = int.MIN_VALUE;

		/**
		 * Entry distribution creation date as Unix timestamp (In seconds)
		 * 
		 **/
		public var createdAt : int = int.MIN_VALUE;

		/**
		 * Entry distribution last update date as Unix timestamp (In seconds)
		 * 
		 **/
		public var updatedAt : int = int.MIN_VALUE;

		/**
		 * Entry distribution submission date as Unix timestamp (In seconds)
		 * 
		 **/
		public var submittedAt : int = int.MIN_VALUE;

		/**
		 **/
		public var entryId : String = null;

		/**
		 **/
		public var partnerId : int = int.MIN_VALUE;

		/**
		 **/
		public var distributionProfileId : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaEntryDistributionStatus
		 **/
		public var status : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaEntryDistributionSunStatus
		 **/
		public var sunStatus : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaEntryDistributionFlag
		 **/
		public var dirtyStatus : int = int.MIN_VALUE;

		/**
		 * Comma separated thumbnail asset ids
		 * 
		 **/
		public var thumbAssetIds : String = null;

		/**
		 * Comma separated flavor asset ids
		 * 
		 **/
		public var flavorAssetIds : String = null;

		/**
		 * Comma separated asset ids
		 * 
		 **/
		public var assetIds : String = null;

		/**
		 * Entry distribution publish time as Unix timestamp (In seconds)
		 * 
		 **/
		public var sunrise : int = int.MIN_VALUE;

		/**
		 * Entry distribution un-publish time as Unix timestamp (In seconds)
		 * 
		 **/
		public var sunset : int = int.MIN_VALUE;

		/**
		 * The id as returned from the distributed destination
		 * 
		 **/
		public var remoteId : String = null;

		/**
		 * The plays as retrieved from the remote destination reports
		 * 
		 **/
		public var plays : int = int.MIN_VALUE;

		/**
		 * The views as retrieved from the remote destination reports
		 * 
		 **/
		public var views : int = int.MIN_VALUE;

		/**
		 **/
		public var validationErrors : Array = null;

		/**
		 * @see com.kaltura.types.KalturaBatchJobErrorTypes
		 **/
		public var errorType : int = int.MIN_VALUE;

		/**
		 **/
		public var errorNumber : int = int.MIN_VALUE;

		/**
		 **/
		public var errorDescription : String = null;

		/**
		 * @see com.kaltura.types.KalturaNullableBoolean
		 **/
		public var hasSubmitResultsLog : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaNullableBoolean
		 **/
		public var hasSubmitSentDataLog : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaNullableBoolean
		 **/
		public var hasUpdateResultsLog : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaNullableBoolean
		 **/
		public var hasUpdateSentDataLog : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaNullableBoolean
		 **/
		public var hasDeleteResultsLog : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaNullableBoolean
		 **/
		public var hasDeleteSentDataLog : int = int.MIN_VALUE;

		/** 
		 * a list of attributes which may be updated on this object 
		 **/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('thumbAssetIds');
			arr.push('flavorAssetIds');
			arr.push('assetIds');
			arr.push('sunrise');
			arr.push('sunset');
			arr.push('validationErrors');
			return arr;
		}

		/** 
		 * a list of attributes which may only be inserted when initializing this object 
		 **/ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('entryId');
			arr.push('distributionProfileId');
			return arr;
		}
	}
}
