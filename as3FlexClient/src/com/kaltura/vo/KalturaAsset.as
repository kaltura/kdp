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
	public dynamic class KalturaAsset extends BaseFlexVo
	{
		/**
		* The ID of the Flavor Asset
		* 
		**/
		public var id : String = null;

		/**
		* The entry ID of the Flavor Asset
		* 
		**/
		public var entryId : String = null;

		/**
		**/
		public var partnerId : int = int.MIN_VALUE;

		/**
		* The version of the Flavor Asset
		* 
		**/
		public var version : int = int.MIN_VALUE;

		/**
		* The size (in KBytes) of the Flavor Asset
		* 
		**/
		public var size : int = int.MIN_VALUE;

		/**
		* Tags used to identify the Flavor Asset in various scenarios
		* 
		**/
		public var tags : String = null;

		/**
		* The file extension
		* 
		**/
		public var fileExt : String = null;

		/**
		**/
		public var createdAt : int = int.MIN_VALUE;

		/**
		**/
		public var updatedAt : int = int.MIN_VALUE;

		/**
		**/
		public var deletedAt : int = int.MIN_VALUE;

		/**
		* System description, error message, warnings and failure cause.
		* 
		**/
		public var description : String = null;

		/**
		* Partner private data
		* 
		**/
		public var partnerData : String = null;

		/**
		* Partner friendly description
		* 
		**/
		public var partnerDescription : String = null;

		/**
		* Comma separated list of source flavor params ids
		* 
		**/
		public var actualSourceAssetParamsIds : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		**/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('tags');
			arr.push('partnerData');
			arr.push('partnerDescription');
			arr.push('actualSourceAssetParamsIds');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		**/ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('fileExt');
			return arr;
		}

		/** 
		* get the expected type of array elements 
		* @param arrayName 	 name of an attribute of type array of the current object 
		* @return 	 un-qualified class name 
		**/ 
		public function getElementType(arrayName:String):String
		{
			var result:String = '';
			switch (arrayName) {
			}
			return result;
		}
	}
}
