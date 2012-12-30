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

	[Bindable]
	public dynamic class KalturaPlayableEntry extends KalturaBaseEntry
	{
		/**
		 * Number of plays
		 * 
		 **/
		public var plays : int = int.MIN_VALUE;

		/**
		 * Number of views
		 * 
		 **/
		public var views : int = int.MIN_VALUE;

		/**
		 * The width in pixels
		 * 
		 **/
		public var width : int = int.MIN_VALUE;

		/**
		 * The height in pixels
		 * 
		 **/
		public var height : int = int.MIN_VALUE;

		/**
		 * The duration in seconds
		 * 
		 **/
		public var duration : int = int.MIN_VALUE;

		/**
		 * The duration in miliseconds
		 * 
		 **/
		public var msDuration : int = int.MIN_VALUE;

		/**
		 * The duration type (short for 0-4 mins, medium for 4-20 mins, long for 20+ mins)
		 * 
		 * @see com.kaltura.types.KalturaDurationType
		 **/
		public var durationType : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('msDuration');
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
