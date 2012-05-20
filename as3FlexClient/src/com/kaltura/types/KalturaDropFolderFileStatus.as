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
	public class KalturaDropFolderFileStatus
	{
		public static const UPLOADING : int = 1;
		public static const PENDING : int = 2;
		public static const WAITING : int = 3;
		public static const HANDLED : int = 4;
		public static const IGNORE : int = 5;
		public static const DELETED : int = 6;
		public static const PURGED : int = 7;
		public static const NO_MATCH : int = 8;
		public static const ERROR_HANDLING : int = 9;
		public static const ERROR_DELETING : int = 10;
		public static const DOWNLOADING : int = 11;
		public static const ERROR_DOWNLOADING : int = 12;
	}
}
