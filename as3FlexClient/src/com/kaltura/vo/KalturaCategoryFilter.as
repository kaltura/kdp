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
	import com.kaltura.vo.KalturaCategoryBaseFilter;

	[Bindable]
	public dynamic class KalturaCategoryFilter extends KalturaCategoryBaseFilter
	{
		/**
		 **/
		public var freeText : String = null;

		/**
		 **/
		public var membersIn : String = null;

		/**
		 **/
		public var nameOrReferenceIdStartsWith : String = null;

		/**
		 **/
		public var managerEqual : String = null;

		/**
		 **/
		public var memberEqual : String = null;

		/**
		 **/
		public var fullNameStartsWithIn : String = null;

		/**
		 * not includes the category itself (only sub categories)
		 * 
		 **/
		public var ancestorIdIn : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('freeText');
			arr.push('membersIn');
			arr.push('nameOrReferenceIdStartsWith');
			arr.push('managerEqual');
			arr.push('memberEqual');
			arr.push('fullNameStartsWithIn');
			arr.push('ancestorIdIn');
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
