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
	public dynamic class KalturaEntryContextDataResult extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var isSiteRestricted : Boolean;

		/** 
		* 		* */ 
		public var isCountryRestricted : Boolean;

		/** 
		* 		* */ 
		public var isSessionRestricted : Boolean;

		/** 
		* 		* */ 
		public var isIpAddressRestricted : Boolean;

		/** 
		* 		* */ 
		public var isUserAgentRestricted : Boolean;

		/** 
		* 		* */ 
		public var previewLength : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var isScheduledNow : Boolean;

		/** 
		* 		* */ 
		public var isAdmin : Boolean;

		/** 
		* 		* */ 
		public var streamerType : String = null;

		/** 
		* 		* */ 
		public var mediaProtocol : String = null;

		/** 
		* 		* */ 
		public var storageProfilesXML : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
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
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		* */ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}

	}
}
