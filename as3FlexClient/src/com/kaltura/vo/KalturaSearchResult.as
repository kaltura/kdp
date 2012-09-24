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
	import com.kaltura.vo.KalturaSearch;

	[Bindable]
	public dynamic class KalturaSearchResult extends KalturaSearch
	{
		/**
		 **/
		public var id : String = null;

		/**
		 **/
		public var title : String = null;

		/**
		 **/
		public var thumbUrl : String = null;

		/**
		 **/
		public var description : String = null;

		/**
		 **/
		public var tags : String = null;

		/**
		 **/
		public var url : String = null;

		/**
		 **/
		public var sourceLink : String = null;

		/**
		 **/
		public var credit : String = null;

		/**
		 * @see com.kaltura.types.KalturaLicenseType
		 **/
		public var licenseType : int = int.MIN_VALUE;

		/**
		 **/
		public var flashPlaybackType : String = null;

		/**
		 **/
		public var fileExt : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('id');
			arr.push('title');
			arr.push('thumbUrl');
			arr.push('description');
			arr.push('tags');
			arr.push('url');
			arr.push('sourceLink');
			arr.push('credit');
			arr.push('licenseType');
			arr.push('flashPlaybackType');
			arr.push('fileExt');
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
