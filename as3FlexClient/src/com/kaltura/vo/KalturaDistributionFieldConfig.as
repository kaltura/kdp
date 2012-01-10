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
	public dynamic class KalturaDistributionFieldConfig extends BaseFlexVo
	{
		/** 
		* Field enum class should be returned by the provider's getFieldEnumClass function.		* */ 
		public var fieldName : String = null;

		/** 
		* 		* */ 
		public var userFriendlyFieldName : String = null;

		/** 
		* An XSLT string that extracts the right value from the Kaltura entry MRSS XML.
The value of the current connector field will be the one that is returned from transforming the Kaltura entry MRSS XML using this XSLT string.		* */ 
		public var entryMrssXslt : String = null;

		/** 
		* 		* */ 
		public var isRequired : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var updateOnChange : Boolean;

		/** 
		* 		* */ 
		public var updateParams : Array = new Array();

		/** 
		* 		* */ 
		public var isDefault : Boolean;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('fieldName');
			arr.push('userFriendlyFieldName');
			arr.push('entryMrssXslt');
			arr.push('isRequired');
			arr.push('updateOnChange');
			arr.push('updateParams');
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
