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
	import com.kaltura.vo.KalturaConfigurableDistributionJobProviderData;

	[Bindable]
	public dynamic class KalturaYouTubeDistributionJobProviderData extends KalturaConfigurableDistributionJobProviderData
	{
		/**
		**/
		public var videoAssetFilePath : String = null;

		/**
		**/
		public var thumbAssetFilePath : String = null;

		/**
		**/
		public var sftpDirectory : String = null;

		/**
		**/
		public var sftpMetadataFilename : String = null;

		/**
		**/
		public var currentPlaylists : String = null;

		/**
		**/
		public var newPlaylists : String = null;

		/**
		**/
		public var submitXml : String = null;

		/**
		**/
		public var updateXml : String = null;

		/**
		**/
		public var deleteXml : String = null;

		/**
		**/
		public var googleClientId : String = null;

		/**
		**/
		public var googleClientSecret : String = null;

		/**
		**/
		public var googleTokenData : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('videoAssetFilePath');
			arr.push('thumbAssetFilePath');
			arr.push('sftpDirectory');
			arr.push('sftpMetadataFilename');
			arr.push('currentPlaylists');
			arr.push('newPlaylists');
			arr.push('submitXml');
			arr.push('updateXml');
			arr.push('deleteXml');
			arr.push('googleClientId');
			arr.push('googleClientSecret');
			arr.push('googleTokenData');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

		override public function getElementType(arrayName:String):String
		{
			var result:String = '';
			switch (arrayName) {
				default:
					result = super.getElementType(arrayName);
					break;
			}
			return result;
		}
	}
}
