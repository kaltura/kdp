/*
This file is part of the Kaltura Collaborative Media Suite which allows users
to do with audio, video, and animation what Wiki platfroms allow them to do with
text.

Copyright (C) 2006-2008  Kaltura Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

@ignore
*/
package com.kaltura.managers.downloadManagers.events
{
	import com.kaltura.assets.abstracts.AbstractAsset;

	import flash.events.Event;

	public class DownloadManagerStatusEvent extends Event
	{
		static public var MEDIA_LOADED:String = "mediaLoaded";
		//static public var count:int = 0;

		public var url:String;
		public var status:int;
		public var asset:AbstractAsset;
		public var roughcutEntryId:String = '-1';
		public var roughcutEntryVersion:int = -1;

		public function DownloadManagerStatusEvent(type:String, roughcut_entry_id:String, roughcut_entry_version:int, source_url:String, source_status:int, source_asset:AbstractAsset):void
		{
			super (type, false, false);
			//++count;
			roughcutEntryId = roughcut_entry_id;
			url = source_url;
			status = source_status;
			asset = source_asset;
			roughcutEntryVersion = roughcut_entry_version;
		}

		override public function clone():Event
		{
			return new DownloadManagerStatusEvent (DownloadManagerStatusEvent.MEDIA_LOADED, roughcutEntryId, roughcutEntryVersion, url, status, asset);
		}
	}
}