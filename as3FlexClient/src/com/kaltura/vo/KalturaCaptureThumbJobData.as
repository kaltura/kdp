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
	import com.kaltura.vo.KalturaJobData;

	[Bindable]
	public dynamic class KalturaCaptureThumbJobData extends KalturaJobData
	{
		/**
		 **/
		public var srcFileSyncLocalPath : String = null;

		/**
		 * The translated path as used by the scheduler
		 * 
		 **/
		public var actualSrcFileSyncLocalPath : String = null;

		/**
		 **/
		public var srcFileSyncRemoteUrl : String = null;

		/**
		 **/
		public var thumbParamsOutputId : int = int.MIN_VALUE;

		/**
		 **/
		public var thumbAssetId : String = null;

		/**
		 **/
		public var srcAssetId : String = null;

		/**
		 * @see com.kaltura.types.KalturaAssetType
		 **/
		public var srcAssetType : String = null;

		/**
		 **/
		public var thumbPath : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('srcFileSyncLocalPath');
			arr.push('actualSrcFileSyncLocalPath');
			arr.push('srcFileSyncRemoteUrl');
			arr.push('thumbParamsOutputId');
			arr.push('thumbAssetId');
			arr.push('srcAssetId');
			arr.push('srcAssetType');
			arr.push('thumbPath');
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
