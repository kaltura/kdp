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
	import com.kaltura.vo.KalturaConfigurableDistributionProfile;

	[Bindable]
	public dynamic class KalturaMetroPcsDistributionProfile extends KalturaConfigurableDistributionProfile
	{
		/**
		 **/
		public var ftpHost : String = null;

		/**
		 **/
		public var ftpLogin : String = null;

		/**
		 **/
		public var ftpPass : String = null;

		/**
		 **/
		public var ftpPath : String = null;

		/**
		 **/
		public var providerName : String = null;

		/**
		 **/
		public var providerId : String = null;

		/**
		 **/
		public var copyright : String = null;

		/**
		 **/
		public var entitlements : String = null;

		/**
		 **/
		public var rating : String = null;

		/**
		 **/
		public var itemType : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('ftpHost');
			arr.push('ftpLogin');
			arr.push('ftpPass');
			arr.push('ftpPath');
			arr.push('providerName');
			arr.push('providerId');
			arr.push('copyright');
			arr.push('entitlements');
			arr.push('rating');
			arr.push('itemType');
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
