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
	public dynamic class KalturaLiveStreamEntry extends KalturaMediaEntry
	{
		/** 
		* 		* */ 
		public var offlineMessage : String = null;

		/** 
		* 		* */ 
		public var streamRemoteId : String = null;

		/** 
		* 		* */ 
		public var streamRemoteBackupId : String = null;

		/** 
		* 		* */ 
		public var bitrates : Array = new Array();

		/** 
		* 		* */ 
		public var primaryBroadcastingUrl : String = null;

		/** 
		* 		* */ 
		public var secondaryBroadcastingUrl : String = null;

		/** 
		* 		* */ 
		public var streamName : String = null;

		/** 
		* 		* */ 
		public var streamUrl : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('offlineMessage');
			arr.push('bitrates');
			arr.push('primaryBroadcastingUrl');
			arr.push('secondaryBroadcastingUrl');
			arr.push('streamName');
			arr.push('streamUrl');
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
