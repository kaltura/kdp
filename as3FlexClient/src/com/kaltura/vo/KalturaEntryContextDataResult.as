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
	import com.kaltura.vo.KalturaContextDataResult;

	[Bindable]
	public dynamic class KalturaEntryContextDataResult extends KalturaContextDataResult
	{
		/**
		* @see com.kaltura.types.kalturaBoolean
		**/
		public var isSiteRestricted : Boolean;

		/**
		* @see com.kaltura.types.kalturaBoolean
		**/
		public var isCountryRestricted : Boolean;

		/**
		* @see com.kaltura.types.kalturaBoolean
		**/
		public var isSessionRestricted : Boolean;

		/**
		* @see com.kaltura.types.kalturaBoolean
		**/
		public var isIpAddressRestricted : Boolean;

		/**
		* @see com.kaltura.types.kalturaBoolean
		**/
		public var isUserAgentRestricted : Boolean;

		/**
		**/
		public var previewLength : int = int.MIN_VALUE;

		/**
		* @see com.kaltura.types.kalturaBoolean
		**/
		public var isScheduledNow : Boolean;

		/**
		* @see com.kaltura.types.kalturaBoolean
		**/
		public var isAdmin : Boolean;

		/**
		* http/rtmp/hdnetwork
		* 
		**/
		public var streamerType : String = null;

		/**
		* http/https, rtmp/rtmpe
		* 
		**/
		public var mediaProtocol : String = null;

		/**
		**/
		public var storageProfilesXML : String = null;

		/**
		* Array of messages as received from the access control rules that invalidated
		* 
		**/
		public var accessControlMessages : Array = null;

		/**
		* Array of actions as received from the access control rules that invalidated
		* 
		**/
		public var accessControlActions : Array = null;

		/**
		* Array of allowed flavor assets according to access control limitations and requested tags
		* 
		**/
		public var flavorAssets : Array = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('isSiteRestricted');
			arr.push('isCountryRestricted');
			arr.push('isSessionRestricted');
			arr.push('isIpAddressRestricted');
			arr.push('isUserAgentRestricted');
			arr.push('previewLength');
			arr.push('isScheduledNow');
			arr.push('isAdmin');
			arr.push('streamerType');
			arr.push('mediaProtocol');
			arr.push('storageProfilesXML');
			arr.push('accessControlMessages');
			arr.push('accessControlActions');
			arr.push('flavorAssets');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

		override public function getElementType(arrayName:String):String
		{
			var result:String = '';
			switch (arrayName) {
				case 'accessControlMessages':
					result = 'KalturaString';
					break;
				case 'accessControlActions':
					result = 'KalturaRuleAction';
					break;
				case 'flavorAssets':
					result = 'KalturaFlavorAsset';
					break;
				default:
					result = super.getElementType(arrayName);
					break;
			}
			return result;
		}
	}
}
