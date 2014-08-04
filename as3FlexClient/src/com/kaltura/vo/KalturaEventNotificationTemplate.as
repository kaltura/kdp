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
	public dynamic class KalturaEventNotificationTemplate extends BaseFlexVo
	{
		/**
		**/
		public var id : int = int.MIN_VALUE;

		/**
		**/
		public var partnerId : int = int.MIN_VALUE;

		/**
		**/
		public var name : String = null;

		/**
		**/
		public var systemName : String = null;

		/**
		**/
		public var description : String = null;

		/**
		* @see com.kaltura.types.KalturaEventNotificationTemplateType
		**/
		public var type : String = null;

		/**
		* @see com.kaltura.types.KalturaEventNotificationTemplateStatus
		**/
		public var status : int = int.MIN_VALUE;

		/**
		**/
		public var createdAt : int = int.MIN_VALUE;

		/**
		**/
		public var updatedAt : int = int.MIN_VALUE;

		/**
		* Define that the template could be dispatched manually from the API
		* 
		* @see com.kaltura.types.kalturaBoolean
		**/
		public var manualDispatchEnabled : Boolean;

		/**
		* Define that the template could be dispatched automatically by the system
		* 
		* @see com.kaltura.types.kalturaBoolean
		**/
		public var automaticDispatchEnabled : Boolean;

		/**
		* Define the event that should trigger this notification
		* 
		* @see com.kaltura.types.KalturaEventNotificationEventType
		**/
		public var eventType : String = null;

		/**
		* Define the object that raied the event that should trigger this notification
		* 
		* @see com.kaltura.types.KalturaEventNotificationEventObjectType
		**/
		public var eventObjectType : String = null;

		/**
		* Define the conditions that cause this notification to be triggered
		* 
		**/
		public var eventConditions : Array = null;

		/**
		* Define the content dynamic parameters
		* 
		**/
		public var contentParameters : Array = null;

		/**
		* Define the content dynamic parameters
		* 
		**/
		public var userParameters : Array = null;

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
			arr.push('manualDispatchEnabled');
			arr.push('automaticDispatchEnabled');
			arr.push('eventType');
			arr.push('eventObjectType');
			arr.push('eventConditions');
			arr.push('contentParameters');
			arr.push('userParameters');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		**/ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('type');
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
				case 'eventConditions':
					result = 'KalturaCondition';
					break;
				case 'contentParameters':
					result = 'KalturaEventNotificationParameter';
					break;
				case 'userParameters':
					result = 'KalturaEventNotificationParameter';
					break;
			}
			return result;
		}
	}
}
