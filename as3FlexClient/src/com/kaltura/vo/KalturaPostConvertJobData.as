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
	import com.kaltura.vo.KalturaConvartableJobData;

	[Bindable]
	public dynamic class KalturaPostConvertJobData extends KalturaConvartableJobData
	{
		/**
		 **/
		public var flavorAssetId : String = null;

		/**
		 * Indicates if a thumbnail should be created
		 * 
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var createThumb : Boolean;

		/**
		 * The path of the created thumbnail
		 * 
		 **/
		public var thumbPath : String = null;

		/**
		 * The position of the thumbnail in the media file
		 * 
		 **/
		public var thumbOffset : int = int.MIN_VALUE;

		/**
		 * The height of the movie, will be used to comapare if this thumbnail is the best we can have
		 * 
		 **/
		public var thumbHeight : int = int.MIN_VALUE;

		/**
		 * The bit rate of the movie, will be used to comapare if this thumbnail is the best we can have
		 * 
		 **/
		public var thumbBitrate : int = int.MIN_VALUE;

		/**
		 **/
		public var customData : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('flavorAssetId');
			arr.push('createThumb');
			arr.push('thumbPath');
			arr.push('thumbOffset');
			arr.push('thumbHeight');
			arr.push('thumbBitrate');
			arr.push('customData');
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
