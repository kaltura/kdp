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
	public dynamic class KalturaAssetParams extends BaseFlexVo
	{
		/**
		* The id of the Flavor Params
		* 
		**/
		public var id : int = int.MIN_VALUE;

		/**
		**/
		public var partnerId : int = int.MIN_VALUE;

		/**
		* The name of the Flavor Params
		* 
		**/
		public var name : String = null;

		/**
		* System name of the Flavor Params
		* 
		**/
		public var systemName : String = null;

		/**
		* The description of the Flavor Params
		* 
		**/
		public var description : String = null;

		/**
		* Creation date as Unix timestamp (In seconds)
		* 
		**/
		public var createdAt : int = int.MIN_VALUE;

		/**
		* True if those Flavor Params are part of system defaults
		* 
		* @see com.kaltura.types.KalturaNullableBoolean
		**/
		public var isSystemDefault : int = int.MIN_VALUE;

		/**
		* The Flavor Params tags are used to identify the flavor for different usage (e.g. web, hd, mobile)
		* 
		**/
		public var tags : String = null;

		/**
		* Array of partner permisison names that required for using this asset params
		* 
		**/
		public var requiredPermissions : Array = null;

		/**
		* Id of remote storage profile that used to get the source, zero indicates Kaltura data center
		* 
		**/
		public var sourceRemoteStorageProfileId : int = int.MIN_VALUE;

		/**
		* Comma seperated ids of remote storage profiles that the flavor distributed to, the distribution done by the conversion engine
		* 
		**/
		public var remoteStorageProfileIds : int = int.MIN_VALUE;

		/**
		* Media parser type to be used for post-conversion validation
		* 
		* @see com.kaltura.types.KalturaMediaParserType
		**/
		public var mediaParserType : String = null;

		/**
		* Comma seperated ids of source flavor params this flavor is created from
		* 
		**/
		public var sourceAssetParamsIds : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		**/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('systemName');
			arr.push('description');
			arr.push('tags');
			arr.push('requiredPermissions');
			arr.push('sourceRemoteStorageProfileId');
			arr.push('remoteStorageProfileIds');
			arr.push('mediaParserType');
			arr.push('sourceAssetParamsIds');
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

		/** 
		* get the expected type of array elements 
		* @param arrayName 	 name of an attribute of type array of the current object 
		* @return 	 un-qualified class name 
		**/ 
		public function getElementType(arrayName:String):String
		{
			var result:String = '';
			switch (arrayName) {
				case 'requiredPermissions':
					result = 'KalturaString';
					break;
			}
			return result;
		}
	}
}
