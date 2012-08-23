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
	import com.kaltura.vo.KalturaBaseEntry;

	import com.kaltura.vo.KalturaCaptionAsset;

	import com.kaltura.vo.BaseFlexVo;

	[Bindable]
	public dynamic class KalturaCaptionAssetItem extends BaseFlexVo
	{
		/**
		 * The Caption Asset object
		 * 
		 **/
		public var asset : KalturaCaptionAsset;

		/**
		 * The entry object
		 * 
		 **/
		public var entry : KalturaBaseEntry;

		/**
		 **/
		public var startTime : int = int.MIN_VALUE;

		/**
		 **/
		public var endTime : int = int.MIN_VALUE;

		/**
		 **/
		public var content : String = null;

		/** 
		 * a list of attributes which may be updated on this object 
		 **/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('asset');
			arr.push('entry');
			arr.push('startTime');
			arr.push('endTime');
			arr.push('content');
			return arr;
		}

		/** 
		 * a list of attributes which may only be inserted when initializing this object 
		 **/ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}
	}
}
