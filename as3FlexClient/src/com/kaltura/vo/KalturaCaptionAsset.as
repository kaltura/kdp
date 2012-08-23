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
	public dynamic class KalturaCaptionAsset extends KalturaAsset
	{
		/**
		 * The Caption Params used to create this Caption Asset
		 * 
		 **/
		public var captionParamsId : int = int.MIN_VALUE;

		/**
		 * The language of the caption asset content
		 * 
		 * @see com.kaltura.types.KalturaLanguage
		 **/
		public var language : String = null;

		/**
		 * The language of the caption asset content
		 * 
		 * @see com.kaltura.types.KalturaLanguageCode
		 **/
		public var languageCode : String = null;

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
		 * The status of the asset
		 * 
		 * @see com.kaltura.types.KalturaCaptionAssetStatus
		 **/
		public var status : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('language');
			arr.push('isDefault');
			arr.push('label');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			arr.push('captionParamsId');
			arr.push('format');
			return arr;
		}
	}
}
