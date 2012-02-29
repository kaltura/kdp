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
	public class KalturaBatchJobType
	{
		public static const CONVERT : String = '0';
		public static const IMPORT : String = '1';
		public static const DELETE : String = '2';
		public static const FLATTEN : String = '3';
		public static const BULKUPLOAD : String = '4';
		public static const DVDCREATOR : String = '5';
		public static const DOWNLOAD : String = '6';
		public static const OOCONVERT : String = '7';
		public static const CONVERT_PROFILE : String = '10';
		public static const POSTCONVERT : String = '11';
		public static const PULL : String = '12';
		public static const REMOTE_CONVERT : String = '13';
		public static const EXTRACT_MEDIA : String = '14';
		public static const MAIL : String = '15';
		public static const NOTIFICATION : String = '16';
		public static const CLEANUP : String = '17';
		public static const SCHEDULER_HELPER : String = '18';
		public static const BULKDOWNLOAD : String = '19';
		public static const DB_CLEANUP : String = '20';
		public static const PROVISION_PROVIDE : String = '21';
		public static const CONVERT_COLLECTION : String = '22';
		public static const STORAGE_EXPORT : String = '23';
		public static const PROVISION_DELETE : String = '24';
		public static const STORAGE_DELETE : String = '25';
		public static const EMAIL_INGESTION : String = '26';
		public static const METADATA_IMPORT : String = '27';
		public static const METADATA_TRANSFORM : String = '28';
		public static const FILESYNC_IMPORT : String = '29';
		public static const CAPTURE_THUMB : String = '30';
		public static const VIRUS_SCAN : String = 'virusScan.VirusScan';
		public static const DISTRIBUTION_SUBMIT : String = 'contentDistribution.DistributionSubmit';
		public static const DISTRIBUTION_UPDATE : String = 'contentDistribution.DistributionUpdate';
		public static const DISTRIBUTION_DELETE : String = 'contentDistribution.DistributionDelete';
		public static const DISTRIBUTION_FETCH_REPORT : String = 'contentDistribution.DistributionFetchReport';
		public static const DISTRIBUTION_ENABLE : String = 'contentDistribution.DistributionEnable';
		public static const DISTRIBUTION_DISABLE : String = 'contentDistribution.DistributionDisable';
		public static const DISTRIBUTION_SYNC : String = 'contentDistribution.DistributionSync';
		public static const DROP_FOLDER_WATCHER : String = 'dropFolder.DropFolderWatcher';
		public static const DROP_FOLDER_HANDLER : String = 'dropFolder.DropFolderHandler';
		public static const PARSE_CAPTION_ASSET : String = 'captionSearch.parseCaptionAsset';
	}
}
