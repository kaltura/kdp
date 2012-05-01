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
	public class KalturaDropFolderFileErrorCode
	{
		public static const ERROR_UPDATE_ENTRY : String = '1';
		public static const ERROR_ADD_ENTRY : String = '2';
		public static const FLAVOR_NOT_FOUND : String = '3';
		public static const FLAVOR_MISSING_IN_FILE_NAME : String = '4';
		public static const SLUG_REGEX_NO_MATCH : String = '5';
		public static const ERROR_READING_FILE : String = '6';
		public static const ERROR_DOWNLOADING_FILE : String = '7';
		public static const LOCAL_FILE_WRONG_SIZE : String = 'dropFolderXmlBulkUpload.LOCAL_FILE_WRONG_SIZE';
		public static const LOCAL_FILE_WRONG_CHECKSUM : String = 'dropFolderXmlBulkUpload.LOCAL_FILE_WRONG_CHECKSUM';
		public static const ERROR_WRITING_TEMP_FILE : String = 'dropFolderXmlBulkUpload.ERROR_WRITING_TEMP_FILE';
		public static const ERROR_ADDING_BULK_UPLOAD : String = 'dropFolderXmlBulkUpload.ERROR_ADDING_BULK_UPLOAD';
	}
}
