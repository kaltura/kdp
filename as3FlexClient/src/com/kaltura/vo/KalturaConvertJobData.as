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
	import com.kaltura.vo.KalturaConvartableJobData;

	[Bindable]
	public dynamic class KalturaConvertJobData extends KalturaConvartableJobData
	{
		/**
		 **/
		public var destFileSyncLocalPath : String = null;

		/**
		 **/
		public var destFileSyncRemoteUrl : String = null;

		/**
		 **/
		public var logFileSyncLocalPath : String = null;

		/**
		 **/
		public var logFileSyncRemoteUrl : String = null;

		/**
		 **/
		public var flavorAssetId : String = null;

		/**
		 **/
		public var remoteMediaId : String = null;

		/**
		 **/
		public var customData : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('destFileSyncLocalPath');
			arr.push('destFileSyncRemoteUrl');
			arr.push('logFileSyncLocalPath');
			arr.push('logFileSyncRemoteUrl');
			arr.push('flavorAssetId');
			arr.push('remoteMediaId');
			arr.push('customData');
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
