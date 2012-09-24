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
	import com.kaltura.vo.KalturaDistributionJobProviderData;

	import com.kaltura.vo.KalturaEntryDistribution;

	import com.kaltura.vo.KalturaDistributionProfile;

	import com.kaltura.vo.KalturaJobData;

	[Bindable]
	public dynamic class KalturaDistributionJobData extends KalturaJobData
	{
		/**
		 **/
		public var distributionProfileId : int = int.MIN_VALUE;

		/**
		 **/
		public var distributionProfile : KalturaDistributionProfile;

		/**
		 **/
		public var entryDistributionId : int = int.MIN_VALUE;

		/**
		 **/
		public var entryDistribution : KalturaEntryDistribution;

		/**
		 * Id of the media in the remote system
		 * 
		 **/
		public var remoteId : String = null;

		/**
		 * @see com.kaltura.types.KalturaDistributionProviderType
		 **/
		public var providerType : String = null;

		/**
		 * Additional data that relevant for the provider only
		 * 
		 **/
		public var providerData : KalturaDistributionJobProviderData;

		/**
		 * The results as returned from the remote destination
		 * 
		 **/
		public var results : String = null;

		/**
		 * The data as sent to the remote destination
		 * 
		 **/
		public var sentData : String = null;

		/**
		 * Stores array of media files that submitted to the destination site
		 * Could be used later for media update
		 * 
		 **/
		public var mediaFiles : Array = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('distributionProfileId');
			arr.push('distributionProfile');
			arr.push('entryDistributionId');
			arr.push('entryDistribution');
			arr.push('remoteId');
			arr.push('providerType');
			arr.push('providerData');
			arr.push('results');
			arr.push('sentData');
			arr.push('mediaFiles');
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
