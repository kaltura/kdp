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
	import com.kaltura.vo.KalturaJobData;

	[Bindable]
	public dynamic class KalturaMoveCategoryEntriesJobData extends KalturaJobData
	{
		/**
		 * Source category id
		 * 
		 **/
		public var srcCategoryId : int = int.MIN_VALUE;

		/**
		 * Destination category id
		 * 
		 **/
		public var destCategoryId : int = int.MIN_VALUE;

		/**
		 * Saves the last category id that its entries moved completely
		 * In case of crash the batch will restart from that point
		 * 
		 **/
		public var lastMovedCategoryId : int = int.MIN_VALUE;

		/**
		 * Saves the last page index of the child categories filter pager
		 * In case of crash the batch will restart from that point
		 * 
		 **/
		public var lastMovedCategoryPageIndex : int = int.MIN_VALUE;

		/**
		 * Saves the last page index of the category entries filter pager
		 * In case of crash the batch will restart from that point
		 * 
		 **/
		public var lastMovedCategoryEntryPageIndex : int = int.MIN_VALUE;

		/**
		 * All entries from all child categories will be moved as well
		 * 
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var moveFromChildren : Boolean;

		/**
		 * Entries won't be deleted from the source entry
		 * 
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var copyOnly : Boolean;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('srcCategoryId');
			arr.push('destCategoryId');
			arr.push('lastMovedCategoryId');
			arr.push('lastMovedCategoryPageIndex');
			arr.push('lastMovedCategoryEntryPageIndex');
			arr.push('moveFromChildren');
			arr.push('copyOnly');
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
