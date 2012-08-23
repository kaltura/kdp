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
	import com.kaltura.vo.KalturaAssetParams;

	[Bindable]
	public dynamic class KalturaThumbParams extends KalturaAssetParams
	{
		/**
		 * @see com.kaltura.types.KalturaThumbCropType
		 **/
		public var cropType : int = int.MIN_VALUE;

		/**
		 **/
		public var quality : int = int.MIN_VALUE;

		/**
		 **/
		public var cropX : int = int.MIN_VALUE;

		/**
		 **/
		public var cropY : int = int.MIN_VALUE;

		/**
		 **/
		public var cropWidth : int = int.MIN_VALUE;

		/**
		 **/
		public var cropHeight : int = int.MIN_VALUE;

		/**
		 **/
		public var videoOffset : Number = Number.NEGATIVE_INFINITY;

		/**
		 **/
		public var width : int = int.MIN_VALUE;

		/**
		 **/
		public var height : int = int.MIN_VALUE;

		/**
		 **/
		public var scaleWidth : Number = Number.NEGATIVE_INFINITY;

		/**
		 **/
		public var scaleHeight : Number = Number.NEGATIVE_INFINITY;

		/**
		 * Hexadecimal value
		 * 
		 **/
		public var backgroundColor : String = null;

		/**
		 * Id of the flavor params or the thumbnail params to be used as source for the thumbnail creation
		 * 
		 **/
		public var sourceParamsId : int = int.MIN_VALUE;

		/**
		 * The container format of the Flavor Params
		 * 
		 * @see com.kaltura.types.KalturaContainerFormat
		 **/
		public var format : String = null;

		/**
		 * The image density (dpi) for example: 72 or 96
		 * 
		 **/
		public var density : int = int.MIN_VALUE;

		/**
		 * Strip profiles and comments
		 * 
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var stripProfiles : Boolean;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('cropType');
			arr.push('quality');
			arr.push('cropX');
			arr.push('cropY');
			arr.push('cropWidth');
			arr.push('cropHeight');
			arr.push('videoOffset');
			arr.push('width');
			arr.push('height');
			arr.push('scaleWidth');
			arr.push('scaleHeight');
			arr.push('backgroundColor');
			arr.push('sourceParamsId');
			arr.push('format');
			arr.push('density');
			arr.push('stripProfiles');
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
