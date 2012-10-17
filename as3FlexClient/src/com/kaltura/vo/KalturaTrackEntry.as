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
	public dynamic class KalturaTrackEntry extends BaseFlexVo
	{
		/**
		 **/
		public var id : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaTrackEntryEventType
		 **/
		public var trackEventType : int = int.MIN_VALUE;

		/**
		 **/
		public var psVersion : String = null;

		/**
		 **/
		public var context : String = null;

		/**
		 **/
		public var partnerId : int = int.MIN_VALUE;

		/**
		 **/
		public var entryId : String = null;

		/**
		 **/
		public var hostName : String = null;

		/**
		 **/
		public var userId : String = null;

		/**
		 **/
		public var changedProperties : String = null;

		/**
		 **/
		public var paramStr1 : String = null;

		/**
		 **/
		public var paramStr2 : String = null;

		/**
		 **/
		public var paramStr3 : String = null;

		/**
		 **/
		public var ks : String = null;

		/**
		 **/
		public var description : String = null;

		/**
		 **/
		public var createdAt : int = int.MIN_VALUE;

		/**
		 **/
		public var updatedAt : int = int.MIN_VALUE;

		/**
		 **/
		public var userIp : String = null;

		/** 
		 * a list of attributes which may be updated on this object 
		 **/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('id');
			arr.push('trackEventType');
			arr.push('psVersion');
			arr.push('context');
			arr.push('partnerId');
			arr.push('entryId');
			arr.push('hostName');
			arr.push('userId');
			arr.push('changedProperties');
			arr.push('paramStr1');
			arr.push('paramStr2');
			arr.push('paramStr3');
			arr.push('ks');
			arr.push('description');
			arr.push('createdAt');
			arr.push('updatedAt');
			arr.push('userIp');
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
