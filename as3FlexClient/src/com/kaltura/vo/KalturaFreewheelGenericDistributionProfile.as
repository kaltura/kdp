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
	public dynamic class KalturaFreewheelGenericDistributionProfile extends KalturaConfigurableDistributionProfile
	{
		/**
		 **/
		public var apikey : String = null;

		/**
		 **/
		public var email : String = null;

		/**
		 **/
		public var sftpPass : String = null;

		/**
		 **/
		public var sftpLogin : String = null;

		/**
		 **/
		public var contentOwner : String = null;

		/**
		 **/
		public var upstreamVideoId : String = null;

		/**
		 **/
		public var upstreamNetworkName : String = null;

		/**
		 **/
		public var upstreamNetworkId : String = null;

		/**
		 **/
		public var categoryId : String = null;

		/**
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var replaceGroup : Boolean;

		/**
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var replaceAirDates : Boolean;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('apikey');
			arr.push('email');
			arr.push('sftpPass');
			arr.push('sftpLogin');
			arr.push('contentOwner');
			arr.push('upstreamVideoId');
			arr.push('upstreamNetworkName');
			arr.push('upstreamNetworkId');
			arr.push('categoryId');
			arr.push('replaceGroup');
			arr.push('replaceAirDates');
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
