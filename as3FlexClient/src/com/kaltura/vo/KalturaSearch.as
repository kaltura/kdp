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
	import com.kaltura.vo.BaseFlexVo;

	[Bindable]
	public dynamic class KalturaSearch extends BaseFlexVo
	{
		/**
		 **/
		public var keyWords : String = null;

		/**
		 * @see com.kaltura.types.KalturaSearchProviderType
		 **/
		public var searchSource : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaMediaType
		 **/
		public var mediaType : int = int.MIN_VALUE;

		/**
		 * Use this field to pass dynamic data for searching
		 * For example - if you set this field to "mymovies_$partner_id"
		 * The $partner_id will be automatically replcaed with your real partner Id
		 * 
		 **/
		public var extraData : String = null;

		/**
		 **/
		public var authData : String = null;

		/** 
		 * a list of attributes which may be updated on this object 
		 **/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('keyWords');
			arr.push('searchSource');
			arr.push('mediaType');
			arr.push('extraData');
			arr.push('authData');
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
