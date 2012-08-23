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
	import com.kaltura.vo.KalturaAsset;

	[Bindable]
	public dynamic class KalturaFlavorAsset extends KalturaAsset
	{
		/**
		 * The Flavor Params used to create this Flavor Asset
		 * 
		 **/
		public var flavorParamsId : int = int.MIN_VALUE;

		/**
		 * The width of the Flavor Asset
		 * 
		 **/
		public var width : int = int.MIN_VALUE;

		/**
		 * The height of the Flavor Asset
		 * 
		 **/
		public var height : int = int.MIN_VALUE;

		/**
		 * The overall bitrate (in KBits) of the Flavor Asset
		 * 
		 **/
		public var bitrate : int = int.MIN_VALUE;

		/**
		 * The frame rate (in FPS) of the Flavor Asset
		 * 
		 **/
		public var frameRate : Number = Number.NEGATIVE_INFINITY;

		/**
		 * True if this Flavor Asset is the original source
		 * 
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var isOriginal : Boolean;

		/**
		 * True if this Flavor Asset is playable in KDP
		 * 
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var isWeb : Boolean;

		/**
		 * The container format
		 * 
		 **/
		public var containerFormat : String = null;

		/**
		 * The video codec
		 * 
		 **/
		public var videoCodecId : String = null;

		/**
		 * The status of the Flavor Asset
		 * 
		 * @see com.kaltura.types.KalturaFlavorAssetStatus
		 **/
		public var status : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			arr.push('flavorParamsId');
			return arr;
		}
	}
}
