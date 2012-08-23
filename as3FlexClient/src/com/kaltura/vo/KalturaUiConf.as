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
	public dynamic class KalturaUiConf extends BaseFlexVo
	{
		/**
		 **/
		public var id : int = int.MIN_VALUE;

		/**
		 * Name of the uiConf, this is not a primary key
		 * 
		 **/
		public var name : String = null;

		/**
		 **/
		public var description : String = null;

		/**
		 **/
		public var partnerId : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaUiConfObjType
		 **/
		public var objType : int = int.MIN_VALUE;

		/**
		 **/
		public var objTypeAsString : String = null;

		/**
		 **/
		public var width : int = int.MIN_VALUE;

		/**
		 **/
		public var height : int = int.MIN_VALUE;

		/**
		 **/
		public var htmlParams : String = null;

		/**
		 **/
		public var swfUrl : String = null;

		/**
		 **/
		public var confFilePath : String = null;

		/**
		 **/
		public var confFile : String = null;

		/**
		 **/
		public var confFileFeatures : String = null;

		/**
		 **/
		public var confVars : String = null;

		/**
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var useCdn : Boolean;

		/**
		 **/
		public var tags : String = null;

		/**
		 **/
		public var swfUrlVersion : String = null;

		/**
		 * Entry creation date as Unix timestamp (In seconds)
		 * 
		 **/
		public var createdAt : int = int.MIN_VALUE;

		/**
		 * Entry creation date as Unix timestamp (In seconds)
		 * 
		 **/
		public var updatedAt : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaUiConfCreationMode
		 **/
		public var creationMode : int = int.MIN_VALUE;

		/**
		 **/
		public var html5Url : String = null;

		/** 
		 * a list of attributes which may be updated on this object 
		 **/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('description');
			arr.push('objType');
			arr.push('width');
			arr.push('height');
			arr.push('htmlParams');
			arr.push('swfUrl');
			arr.push('confFile');
			arr.push('confFileFeatures');
			arr.push('confVars');
			arr.push('useCdn');
			arr.push('tags');
			arr.push('swfUrlVersion');
			arr.push('creationMode');
			arr.push('html5Url');
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
