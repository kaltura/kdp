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
package com.kaltura.types
{
	public class KalturaDwhHourlyPartnerOrderBy
	{
		public static const AGGREGATED_TIME_ASC : String = '+aggregatedTime';
		public static const AGGREGATED_TIME_DESC : String = '-aggregatedTime';
		public static const SUM_TIME_VIEWED_ASC : String = '+sumTimeViewed';
		public static const SUM_TIME_VIEWED_DESC : String = '-sumTimeViewed';
		public static const AVERAGE_TIME_VIEWED_ASC : String = '+averageTimeViewed';
		public static const AVERAGE_TIME_VIEWED_DESC : String = '-averageTimeViewed';
		public static const COUNT_PLAYS_ASC : String = '+countPlays';
		public static const COUNT_PLAYS_DESC : String = '-countPlays';
		public static const COUNT_LOADS_ASC : String = '+countLoads';
		public static const COUNT_LOADS_DESC : String = '-countLoads';
		public static const COUNT_PLAYS25_ASC : String = '+countPlays25';
		public static const COUNT_PLAYS25_DESC : String = '-countPlays25';
		public static const COUNT_PLAYS50_ASC : String = '+countPlays50';
		public static const COUNT_PLAYS50_DESC : String = '-countPlays50';
		public static const COUNT_PLAYS75_ASC : String = '+countPlays75';
		public static const COUNT_PLAYS75_DESC : String = '-countPlays75';
		public static const COUNT_PLAYS100_ASC : String = '+countPlays100';
		public static const COUNT_PLAYS100_DESC : String = '-countPlays100';
		public static const COUNT_EDIT_ASC : String = '+countEdit';
		public static const COUNT_EDIT_DESC : String = '-countEdit';
		public static const COUNT_SHARES_ASC : String = '+countShares';
		public static const COUNT_SHARES_DESC : String = '-countShares';
		public static const COUNT_DOWNLOAD_ASC : String = '+countDownload';
		public static const COUNT_DOWNLOAD_DESC : String = '-countDownload';
		public static const COUNT_REPORT_ABUSE_ASC : String = '+countReportAbuse';
		public static const COUNT_REPORT_ABUSE_DESC : String = '-countReportAbuse';
		public static const COUNT_MEDIA_ENTRIES_ASC : String = '+countMediaEntries';
		public static const COUNT_MEDIA_ENTRIES_DESC : String = '-countMediaEntries';
		public static const COUNT_VIDEO_ENTRIES_ASC : String = '+countVideoEntries';
		public static const COUNT_VIDEO_ENTRIES_DESC : String = '-countVideoEntries';
		public static const COUNT_IMAGE_ENTRIES_ASC : String = '+countImageEntries';
		public static const COUNT_IMAGE_ENTRIES_DESC : String = '-countImageEntries';
		public static const COUNT_AUDIO_ENTRIES_ASC : String = '+countAudioEntries';
		public static const COUNT_AUDIO_ENTRIES_DESC : String = '-countAudioEntries';
		public static const COUNT_MIX_ENTRIES_ASC : String = '+countMixEntries';
		public static const COUNT_MIX_ENTRIES_DESC : String = '-countMixEntries';
		public static const COUNT_PLAYLISTS_ASC : String = '+countPlaylists';
		public static const COUNT_PLAYLISTS_DESC : String = '-countPlaylists';
		public static const COUNT_BANDWIDTH_ASC : String = '+countBandwidth';
		public static const COUNT_BANDWIDTH_DESC : String = '-countBandwidth';
		public static const COUNT_STORAGE_ASC : String = '+countStorage';
		public static const COUNT_STORAGE_DESC : String = '-countStorage';
		public static const COUNT_USERS_ASC : String = '+countUsers';
		public static const COUNT_USERS_DESC : String = '-countUsers';
		public static const COUNT_WIDGETS_ASC : String = '+countWidgets';
		public static const COUNT_WIDGETS_DESC : String = '-countWidgets';
		public static const AGGREGATED_STORAGE_ASC : String = '+aggregatedStorage';
		public static const AGGREGATED_STORAGE_DESC : String = '-aggregatedStorage';
		public static const AGGREGATED_BANDWIDTH_ASC : String = '+aggregatedBandwidth';
		public static const AGGREGATED_BANDWIDTH_DESC : String = '-aggregatedBandwidth';
		public static const COUNT_BUFFER_START_ASC : String = '+countBufferStart';
		public static const COUNT_BUFFER_START_DESC : String = '-countBufferStart';
		public static const COUNT_BUFFER_END_ASC : String = '+countBufferEnd';
		public static const COUNT_BUFFER_END_DESC : String = '-countBufferEnd';
		public static const COUNT_OPEN_FULL_SCREEN_ASC : String = '+countOpenFullScreen';
		public static const COUNT_OPEN_FULL_SCREEN_DESC : String = '-countOpenFullScreen';
		public static const COUNT_CLOSE_FULL_SCREEN_ASC : String = '+countCloseFullScreen';
		public static const COUNT_CLOSE_FULL_SCREEN_DESC : String = '-countCloseFullScreen';
		public static const COUNT_REPLAY_ASC : String = '+countReplay';
		public static const COUNT_REPLAY_DESC : String = '-countReplay';
		public static const COUNT_SEEK_ASC : String = '+countSeek';
		public static const COUNT_SEEK_DESC : String = '-countSeek';
		public static const COUNT_OPEN_UPLOAD_ASC : String = '+countOpenUpload';
		public static const COUNT_OPEN_UPLOAD_DESC : String = '-countOpenUpload';
		public static const COUNT_SAVE_PUBLISH_ASC : String = '+countSavePublish';
		public static const COUNT_SAVE_PUBLISH_DESC : String = '-countSavePublish';
		public static const COUNT_CLOSE_EDITOR_ASC : String = '+countCloseEditor';
		public static const COUNT_CLOSE_EDITOR_DESC : String = '-countCloseEditor';
		public static const COUNT_PRE_BUMPER_PLAYED_ASC : String = '+countPreBumperPlayed';
		public static const COUNT_PRE_BUMPER_PLAYED_DESC : String = '-countPreBumperPlayed';
		public static const COUNT_POST_BUMPER_PLAYED_ASC : String = '+countPostBumperPlayed';
		public static const COUNT_POST_BUMPER_PLAYED_DESC : String = '-countPostBumperPlayed';
		public static const COUNT_BUMPER_CLICKED_ASC : String = '+countBumperClicked';
		public static const COUNT_BUMPER_CLICKED_DESC : String = '-countBumperClicked';
		public static const COUNT_PREROLL_STARTED_ASC : String = '+countPrerollStarted';
		public static const COUNT_PREROLL_STARTED_DESC : String = '-countPrerollStarted';
		public static const COUNT_MIDROLL_STARTED_ASC : String = '+countMidrollStarted';
		public static const COUNT_MIDROLL_STARTED_DESC : String = '-countMidrollStarted';
		public static const COUNT_POSTROLL_STARTED_ASC : String = '+countPostrollStarted';
		public static const COUNT_POSTROLL_STARTED_DESC : String = '-countPostrollStarted';
		public static const COUNT_OVERLAY_STARTED_ASC : String = '+countOverlayStarted';
		public static const COUNT_OVERLAY_STARTED_DESC : String = '-countOverlayStarted';
		public static const COUNT_PREROLL_CLICKED_ASC : String = '+countPrerollClicked';
		public static const COUNT_PREROLL_CLICKED_DESC : String = '-countPrerollClicked';
		public static const COUNT_MIDROLL_CLICKED_ASC : String = '+countMidrollClicked';
		public static const COUNT_MIDROLL_CLICKED_DESC : String = '-countMidrollClicked';
		public static const COUNT_POSTROLL_CLICKED_ASC : String = '+countPostrollClicked';
		public static const COUNT_POSTROLL_CLICKED_DESC : String = '-countPostrollClicked';
		public static const COUNT_OVERLAY_CLICKED_ASC : String = '+countOverlayClicked';
		public static const COUNT_OVERLAY_CLICKED_DESC : String = '-countOverlayClicked';
		public static const COUNT_PREROLL25_ASC : String = '+countPreroll25';
		public static const COUNT_PREROLL25_DESC : String = '-countPreroll25';
		public static const COUNT_PREROLL50_ASC : String = '+countPreroll50';
		public static const COUNT_PREROLL50_DESC : String = '-countPreroll50';
		public static const COUNT_PREROLL75_ASC : String = '+countPreroll75';
		public static const COUNT_PREROLL75_DESC : String = '-countPreroll75';
		public static const COUNT_MIDROLL25_ASC : String = '+countMidroll25';
		public static const COUNT_MIDROLL25_DESC : String = '-countMidroll25';
		public static const COUNT_MIDROLL50_ASC : String = '+countMidroll50';
		public static const COUNT_MIDROLL50_DESC : String = '-countMidroll50';
		public static const COUNT_MIDROLL75_ASC : String = '+countMidroll75';
		public static const COUNT_MIDROLL75_DESC : String = '-countMidroll75';
		public static const COUNT_POSTROLL25_ASC : String = '+countPostroll25';
		public static const COUNT_POSTROLL25_DESC : String = '-countPostroll25';
		public static const COUNT_POSTROLL50_ASC : String = '+countPostroll50';
		public static const COUNT_POSTROLL50_DESC : String = '-countPostroll50';
		public static const COUNT_POSTROLL75_ASC : String = '+countPostroll75';
		public static const COUNT_POSTROLL75_DESC : String = '-countPostroll75';
		public static const COUNT_LIVE_STREAMING_BANDWIDTH_ASC : String = '+countLiveStreamingBandwidth';
		public static const COUNT_LIVE_STREAMING_BANDWIDTH_DESC : String = '-countLiveStreamingBandwidth';
		public static const AGGREGATED_LIVE_STREAMING_BANDWIDTH_ASC : String = '+aggregatedLiveStreamingBandwidth';
		public static const AGGREGATED_LIVE_STREAMING_BANDWIDTH_DESC : String = '-aggregatedLiveStreamingBandwidth';
	}
}
