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
package com.kaltura.components.players.events
{
	import com.kaltura.assets.abstracts.AbstractAsset;

	import flash.events.Event;

	public class PlayerEvent extends Event
	{
		public static const ROUGHCUT_UPDATE_PLAYHEAD:String = "roughcutUpdatePlayhead";
		public static const UPDATE_PLAYHEAD_NEW_ASSET:String = "updatePlayheadNewAsset";
		public static const ROUGHCUT_PLAY_END:String = "roughcutPlayEnd";
		public static const ROUGHCUT_PAUSE:String = "roughcutPause";
		public static const SINGLE_VIDEO_UPDATE_PLAYHEAD:String = "singleVideoUpdatePlayhead";
		public static const SINGLE_VIDEO_PLAY_END:String = "singleVideoPlayEnd";
		public static const DOWNLOAD_COMPLETE:String = "downloadComplete";

		public var playheadTime:Number = 0;
		public var assetIndex:int = -1;
		public var currentAsset:AbstractAsset = null;

		public function PlayerEvent(type:String, playhead_time:Number, asset_index:int = -1, asset:AbstractAsset = null):void
		{
			super(type, true, false);
			currentAsset = asset;
			playheadTime = playhead_time;
			assetIndex = asset_index;
		}

		override public function clone():Event
		{
			return new PlayerEvent (type, playheadTime, assetIndex, currentAsset);
		}
	}
}