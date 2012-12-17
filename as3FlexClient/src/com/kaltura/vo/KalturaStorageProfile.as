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
	public dynamic class KalturaStorageProfile extends BaseFlexVo
	{
		/**
		 **/
		public var id : int = int.MIN_VALUE;

		/**
		 **/
		public var createdAt : int = int.MIN_VALUE;

		/**
		 **/
		public var updatedAt : int = int.MIN_VALUE;

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
		public var desciption : String = null;

		/**
		 * @see com.kaltura.types.KalturaStorageProfileStatus
		 **/
		public var status : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaStorageProfileProtocol
		 **/
		public var protocol : int = int.MIN_VALUE;

		/**
		 **/
		public var storageUrl : String = null;

		/**
		 **/
		public var storageBaseDir : String = null;

		/**
		 **/
		public var storageUsername : String = null;

		/**
		 **/
		public var storagePassword : String = null;

		/**
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var storageFtpPassiveMode : Boolean;

		/**
		 **/
		public var deliveryHttpBaseUrl : String = null;

		/**
		 **/
		public var deliveryRmpBaseUrl : String = null;

		/**
		 **/
		public var deliveryIisBaseUrl : String = null;

		/**
		 **/
		public var minFileSize : int = int.MIN_VALUE;

		/**
		 **/
		public var maxFileSize : int = int.MIN_VALUE;

		/**
		 **/
		public var flavorParamsIds : String = null;

		/**
		 **/
		public var maxConcurrentConnections : int = int.MIN_VALUE;

		/**
		 **/
		public var pathManagerClass : String = null;

		/**
		 **/
		public var pathManagerParams : Array = null;

		/**
		 **/
		public var urlManagerClass : String = null;

		/**
		 **/
		public var urlManagerParams : Array = null;

		/**
		 * No need to create enum for temp field
		 * 
		 **/
		public var trigger : int = int.MIN_VALUE;

		/**
		 * Delivery Priority
		 * 
		 **/
		public var deliveryPriority : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaStorageProfileDeliveryStatus
		 **/
		public var deliveryStatus : int = int.MIN_VALUE;

		/**
		 **/
		public var rtmpPrefix : String = null;

		/**
		 * @see com.kaltura.types.KalturaStorageProfileReadyBehavior
		 **/
		public var readyBehavior : int = int.MIN_VALUE;

		/**
		 * Flag sugnifying that the storage exported content should be deleted when soure entry is deleted
		 * 
		 **/
		public var allowAutoDelete : int = int.MIN_VALUE;

		/** 
		 * a list of attributes which may be updated on this object 
		 **/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('systemName');
			arr.push('desciption');
			arr.push('status');
			arr.push('protocol');
			arr.push('storageUrl');
			arr.push('storageBaseDir');
			arr.push('storageUsername');
			arr.push('storagePassword');
			arr.push('storageFtpPassiveMode');
			arr.push('deliveryHttpBaseUrl');
			arr.push('deliveryRmpBaseUrl');
			arr.push('deliveryIisBaseUrl');
			arr.push('minFileSize');
			arr.push('maxFileSize');
			arr.push('flavorParamsIds');
			arr.push('maxConcurrentConnections');
			arr.push('pathManagerClass');
			arr.push('pathManagerParams');
			arr.push('urlManagerClass');
			arr.push('urlManagerParams');
			arr.push('trigger');
			arr.push('deliveryPriority');
			arr.push('deliveryStatus');
			arr.push('rtmpPrefix');
			arr.push('readyBehavior');
			arr.push('allowAutoDelete');
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
