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
	public dynamic class KalturaWidget extends BaseFlexVo
	{
		/**
		 **/
		public var id : String = null;

		/**
		 **/
		public var sourceWidgetId : String = null;

		/**
		 **/
		public var rootWidgetId : String = null;

		/**
		 **/
		public var partnerId : int = int.MIN_VALUE;

		/**
		 **/
		public var entryId : String = null;

		/**
		 **/
		public var uiConfId : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaWidgetSecurityType
		 **/
		public var securityType : int = int.MIN_VALUE;

		/**
		 **/
		public var securityPolicy : int = int.MIN_VALUE;

		/**
		 **/
		public var createdAt : int = int.MIN_VALUE;

		/**
		 **/
		public var updatedAt : int = int.MIN_VALUE;

		/**
		 * Can be used to store various partner related data as a string
		 * 
		 **/
		public var partnerData : String = null;

		/**
		 **/
		public var widgetHTML : String = null;

		/**
		 * Should enforce entitlement on feed entries
		 * 
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var enforceEntitlement : Boolean;

		/**
		 * Set privacy context for search entries that assiged to private and public categories within a category privacy context.
		 * 
		 **/
		public var privacyContext : String = null;

		/**
		 * Addes the HTML5 script line to the widget's embed code
		 * 
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var addEmbedHtml5Support : Boolean;

		/** 
		 * a list of attributes which may be updated on this object 
		 **/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('sourceWidgetId');
			arr.push('entryId');
			arr.push('uiConfId');
			arr.push('securityType');
			arr.push('securityPolicy');
			arr.push('partnerData');
			arr.push('enforceEntitlement');
			arr.push('privacyContext');
			arr.push('addEmbedHtml5Support');
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
