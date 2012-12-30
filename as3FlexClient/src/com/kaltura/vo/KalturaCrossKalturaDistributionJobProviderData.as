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
	import com.kaltura.vo.KalturaConfigurableDistributionJobProviderData;

	[Bindable]
	public dynamic class KalturaCrossKalturaDistributionJobProviderData extends KalturaConfigurableDistributionJobProviderData
	{
		/**
		 * Key-value array where the keys are IDs of distributed flavor assets in the source account and the values are the matching IDs in the target account
		 * 
		 **/
		public var distributedFlavorAssets : String = null;

		/**
		 * Key-value array where the keys are IDs of distributed thumb assets in the source account and the values are the matching IDs in the target account
		 * 
		 **/
		public var distributedThumbAssets : String = null;

		/**
		 * Key-value array where the keys are IDs of distributed metadata objects in the source account and the values are the matching IDs in the target account
		 * 
		 **/
		public var distributedMetadata : String = null;

		/**
		 * Key-value array where the keys are IDs of distributed caption assets in the source account and the values are the matching IDs in the target account
		 * 
		 **/
		public var distributedCaptionAssets : String = null;

		/**
		 * Key-value array where the keys are IDs of distributed cue points in the source account and the values are the matching IDs in the target account
		 * 
		 **/
		public var distributedCuePoints : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('distributedFlavorAssets');
			arr.push('distributedThumbAssets');
			arr.push('distributedMetadata');
			arr.push('distributedCaptionAssets');
			arr.push('distributedCuePoints');
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
