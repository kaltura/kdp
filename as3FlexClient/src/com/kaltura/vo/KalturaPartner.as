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
	public dynamic class KalturaPartner extends BaseFlexVo
	{
		/**
		**/
		public var id : int = int.MIN_VALUE;

		/**
		**/
		public var name : String = null;

		/**
		**/
		public var website : String = null;

		/**
		**/
		public var notificationUrl : String = null;

		/**
		**/
		public var appearInSearch : int = int.MIN_VALUE;

		/**
		**/
		public var createdAt : int = int.MIN_VALUE;

		/**
		* deprecated - lastName and firstName replaces this field
		* 
		**/
		public var adminName : String = null;

		/**
		**/
		public var adminEmail : String = null;

		/**
		**/
		public var description : String = null;

		/**
		* @see com.kaltura.types.KalturaCommercialUseType
		**/
		public var commercialUse : int = int.MIN_VALUE;

		/**
		**/
		public var landingPage : String = null;

		/**
		**/
		public var userLandingPage : String = null;

		/**
		**/
		public var contentCategories : String = null;

		/**
		* @see com.kaltura.types.KalturaPartnerType
		**/
		public var type : int = int.MIN_VALUE;

		/**
		**/
		public var phone : String = null;

		/**
		**/
		public var describeYourself : String = null;

		/**
		* @see com.kaltura.types.kalturaBoolean
		**/
		public var adultContent : Boolean;

		/**
		**/
		public var defConversionProfileType : String = null;

		/**
		**/
		public var notify : int = int.MIN_VALUE;

		/**
		* @see com.kaltura.types.KalturaPartnerStatus
		**/
		public var status : int = int.MIN_VALUE;

		/**
		**/
		public var allowQuickEdit : int = int.MIN_VALUE;

		/**
		**/
		public var mergeEntryLists : int = int.MIN_VALUE;

		/**
		**/
		public var notificationsConfig : String = null;

		/**
		**/
		public var maxUploadSize : int = int.MIN_VALUE;

		/**
		**/
		public var partnerPackage : int = int.MIN_VALUE;

		/**
		**/
		public var secret : String = null;

		/**
		**/
		public var adminSecret : String = null;

		/**
		**/
		public var cmsPassword : String = null;

		/**
		**/
		public var allowMultiNotification : int = int.MIN_VALUE;

		/**
		**/
		public var adminLoginUsersQuota : int = int.MIN_VALUE;

		/**
		**/
		public var adminUserId : String = null;

		/**
		* firstName and lastName replace the old (deprecated) adminName
		* 
		**/
		public var firstName : String = null;

		/**
		* lastName and firstName replace the old (deprecated) adminName
		* 
		**/
		public var lastName : String = null;

		/**
		* country code (2char) - this field is optional
		* 
		**/
		public var country : String = null;

		/**
		* state code (2char) - this field is optional
		* 
		**/
		public var state : String = null;

		/**
		**/
		public var additionalParams : Array = null;

		/**
		**/
		public var publishersQuota : int = int.MIN_VALUE;

		/**
		* @see com.kaltura.types.KalturaPartnerGroupType
		**/
		public var partnerGroupType : int = int.MIN_VALUE;

		/**
		* @see com.kaltura.types.kalturaBoolean
		**/
		public var defaultEntitlementEnforcement : Boolean;

		/**
		**/
		public var defaultDeliveryType : String = null;

		/**
		**/
		public var defaultEmbedCodeType : String = null;

		/**
		**/
		public var deliveryTypes : Array = null;

		/**
		**/
		public var embedCodeTypes : Array = null;

		/**
		**/
		public var templatePartnerId : int = int.MIN_VALUE;

		/**
		* @see com.kaltura.types.kalturaBoolean
		**/
		public var ignoreSeoLinks : Boolean;

		/**
		**/
		public var host : String = null;

		/**
		**/
		public var cdnHost : String = null;

		/**
		**/
		public var rtmpUrl : String = null;

		/**
		* @see com.kaltura.types.kalturaBoolean
		**/
		public var isFirstLogin : Boolean;

		/**
		**/
		public var logoutUrl : String = null;

		/**
		**/
		public var partnerParentId : int = int.MIN_VALUE;

		/** 
		* a list of attributes which may be updated on this object 
		**/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('website');
			arr.push('notificationUrl');
			arr.push('appearInSearch');
			arr.push('adminName');
			arr.push('adminEmail');
			arr.push('description');
			arr.push('commercialUse');
			arr.push('landingPage');
			arr.push('userLandingPage');
			arr.push('contentCategories');
			arr.push('type');
			arr.push('phone');
			arr.push('describeYourself');
			arr.push('adultContent');
			arr.push('defConversionProfileType');
			arr.push('notify');
			arr.push('allowQuickEdit');
			arr.push('mergeEntryLists');
			arr.push('notificationsConfig');
			arr.push('maxUploadSize');
			arr.push('allowMultiNotification');
			arr.push('adminUserId');
			arr.push('firstName');
			arr.push('lastName');
			arr.push('country');
			arr.push('state');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		**/ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('additionalParams');
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
				case 'additionalParams':
					result = 'KalturaKeyValue';
					break;
				case 'deliveryTypes':
					result = 'KalturaPlayerDeliveryType';
					break;
				case 'embedCodeTypes':
					result = 'KalturaPlayerEmbedCodeType';
					break;
			}
			return result;
		}
	}
}
