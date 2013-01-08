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
	import com.kaltura.vo.KalturaJobData;

	[Bindable]
	public dynamic class KalturaProvisionJobData extends KalturaJobData
	{
		/**
		 **/
		public var streamID : String = null;

		/**
		 **/
		public var backupStreamID : String = null;

		/**
		 **/
		public var rtmp : String = null;

		/**
		 **/
		public var encoderIP : String = null;

		/**
		 **/
		public var backupEncoderIP : String = null;

		/**
		 **/
		public var encoderPassword : String = null;

		/**
		 **/
		public var encoderUsername : String = null;

		/**
		 **/
		public var endDate : int = int.MIN_VALUE;

		/**
		 **/
		public var returnVal : String = null;

		/**
		 **/
		public var mediaType : int = int.MIN_VALUE;

		/**
		 **/
		public var primaryBroadcastingUrl : String = null;

		/**
		 **/
		public var secondaryBroadcastingUrl : String = null;

		/**
		 **/
		public var streamName : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('streamID');
			arr.push('backupStreamID');
			arr.push('rtmp');
			arr.push('encoderIP');
			arr.push('backupEncoderIP');
			arr.push('encoderPassword');
			arr.push('encoderUsername');
			arr.push('endDate');
			arr.push('returnVal');
			arr.push('mediaType');
			arr.push('primaryBroadcastingUrl');
			arr.push('secondaryBroadcastingUrl');
			arr.push('streamName');
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
