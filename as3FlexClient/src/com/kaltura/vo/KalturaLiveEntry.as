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
	import com.kaltura.vo.KalturaMediaEntry;

	[Bindable]
	public dynamic class KalturaLiveEntry extends KalturaMediaEntry
	{
		/**
		* The message to be presented when the stream is offline
		* 
		**/
		public var offlineMessage : String = null;

		/**
		* Recording Status Enabled/Disabled
		* 
		* @see com.kaltura.types.KalturaRecordStatus
		**/
		public var recordStatus : int = int.MIN_VALUE;

		/**
		* DVR Status Enabled/Disabled
		* 
		* @see com.kaltura.types.KalturaDVRStatus
		**/
		public var dvrStatus : int = int.MIN_VALUE;

		/**
		* Window of time which the DVR allows for backwards scrubbing (in minutes)
		* 
		**/
		public var dvrWindow : int = int.MIN_VALUE;

		/**
		* Array of key value protocol->live stream url objects
		* 
		**/
		public var liveStreamConfigurations : Array = null;

		/**
		* Recorded entry id
		* 
		**/
		public var recordedEntryId : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('offlineMessage');
			arr.push('liveStreamConfigurations');
			arr.push('recordedEntryId');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			arr.push('recordStatus');
			arr.push('dvrStatus');
			arr.push('dvrWindow');
			return arr;
		}

		override public function getElementType(arrayName:String):String
		{
			var result:String = '';
			switch (arrayName) {
				case 'liveStreamConfigurations':
					result = 'KalturaLiveStreamConfiguration';
					break;
				default:
					result = super.getElementType(arrayName);
					break;
			}
			return result;
		}
	}
}
