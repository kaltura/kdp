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
	import com.kaltura.vo.KalturaFilter;

	import com.kaltura.vo.KalturaJobData;

	[Bindable]
	public dynamic class KalturaIndexJobData extends KalturaJobData
	{
		/**
		 * The filter should return the list of objects that need to be reindexed.
		 * 
		 **/
		public var filter : KalturaFilter;

		/**
		 * Indicates the last id that reindexed, used when the batch crached, to re-run from the last crash point.
		 * 
		 **/
		public var lastIndexId : int = int.MIN_VALUE;

		/**
		 * Indicates that the object columns and attributes values should be recalculated before reindexed.
		 * 
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var shouldUpdate : Boolean;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('filter');
			arr.push('lastIndexId');
			arr.push('shouldUpdate');
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
