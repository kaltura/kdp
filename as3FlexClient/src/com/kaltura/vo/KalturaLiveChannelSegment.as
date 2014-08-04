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
	public dynamic class KalturaLiveChannelSegment extends BaseFlexVo
	{
		/**
		* Unique identifier
		* 
		**/
		public var id : String = null;

		/**
		**/
		public var partnerId : int = int.MIN_VALUE;

		/**
		* Segment creation date as Unix timestamp (In seconds)
		* 
		**/
		public var createdAt : int = int.MIN_VALUE;

		/**
		* Segment update date as Unix timestamp (In seconds)
		* 
		**/
		public var updatedAt : int = int.MIN_VALUE;

		/**
		* Segment name
		* 
		**/
		public var name : String = null;

		/**
		* Segment description
		* 
		**/
		public var description : String = null;

		/**
		* Segment tags
		* 
		**/
		public var tags : String = null;

		/**
		* Segment could be associated with the main stream, as additional stream or as overlay
		* 
		* @see com.kaltura.types.KalturaLiveChannelSegmentType
		**/
		public var type : String = null;

		/**
		* @see com.kaltura.types.KalturaLiveChannelSegmentStatus
		**/
		public var status : String = null;

		/**
		* Live channel id
		* 
		**/
		public var channelId : String = null;

		/**
		* Entry id to be played
		* 
		**/
		public var entryId : String = null;

		/**
		* Segment start time trigger type
		* 
		* @see com.kaltura.types.KalturaLiveChannelSegmentTriggerType
		**/
		public var triggerType : String = null;

		/**
		* Live channel segment that the trigger relates to
		* 
		**/
		public var triggerSegmentId : String = null;

		/**
		* Segment play start time, in mili-seconds, according to trigger type
		* 
		**/
		public var startTime : Number = Number.NEGATIVE_INFINITY;

		/**
		* Segment play duration time, in mili-seconds
		* 
		**/
		public var duration : Number = Number.NEGATIVE_INFINITY;

		/** 
		* a list of attributes which may be updated on this object 
		**/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('description');
			arr.push('tags');
			arr.push('type');
			arr.push('channelId');
			arr.push('entryId');
			arr.push('triggerType');
			arr.push('triggerSegmentId');
			arr.push('startTime');
			arr.push('duration');
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
			}
			return result;
		}
	}
}
