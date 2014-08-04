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
package com.kaltura.commands.mediaServer
{
		import com.kaltura.vo.KalturaMediaServerStatus;
	import com.kaltura.delegates.mediaServer.MediaServerReportStatusDelegate;
	import com.kaltura.net.KalturaCall;

	/**
	* Update media server status
	* 
	**/
	public class MediaServerReportStatus extends KalturaCall
	{
		public var filterFields : String;
		
		/**
		* @param hostname String
		* @param mediaServerStatus KalturaMediaServerStatus
		**/
		public function MediaServerReportStatus( hostname : String,mediaServerStatus : KalturaMediaServerStatus )
		{
			service= 'mediaserver';
			action= 'reportStatus';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('hostname');
			valueArr.push(hostname);
				keyValArr = kalturaObject2Arrays(mediaServerStatus, 'mediaServerStatus');
				keyArr = keyArr.concat(keyValArr[0]);
				valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MediaServerReportStatusDelegate( this , config );
		}
	}
}
