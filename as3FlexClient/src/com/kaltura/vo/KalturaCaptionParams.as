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
	public dynamic class KalturaCaptionParams extends KalturaAssetParams
	{
		/**
		 * The language of the caption content
		 * 
		 * @see com.kaltura.types.KalturaLanguage
		 **/
		public var language : String = null;

		/**
		 * Is default caption asset of the entry
		 * 
		 * @see com.kaltura.types.KalturaNullableBoolean
		 **/
		public var isDefault : int = int.MIN_VALUE;

		/**
		 * Friendly label
		 * 
		 **/
		public var label : String = null;

		/**
		 * The caption format
		 * 
		 * @see com.kaltura.types.KalturaCaptionType
		 **/
		public var format : String = null;

		/**
		 * Id of the caption params or the flavor params to be used as source for the caption creation
		 * 
		 **/
		public var sourceParamsId : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('isDefault');
			arr.push('label');
			arr.push('sourceParamsId');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			arr.push('language');
			arr.push('format');
			return arr;
		}
	}
}
