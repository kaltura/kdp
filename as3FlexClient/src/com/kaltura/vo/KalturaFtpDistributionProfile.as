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
	import com.kaltura.vo.KalturaConfigurableDistributionProfile;

	[Bindable]
	public dynamic class KalturaFtpDistributionProfile extends KalturaConfigurableDistributionProfile
	{
		/**
		 * @see com.kaltura.types.KalturaDistributionProtocol
		 **/
		public var protocol : int = int.MIN_VALUE;

		/**
		 **/
		public var host : String = null;

		/**
		 **/
		public var port : int = int.MIN_VALUE;

		/**
		 **/
		public var basePath : String = null;

		/**
		 **/
		public var username : String = null;

		/**
		 **/
		public var password : String = null;

		/**
		 **/
		public var passphrase : String = null;

		/**
		 **/
		public var sftpPublicKey : String = null;

		/**
		 **/
		public var sftpPrivateKey : String = null;

		/**
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var disableMetadata : Boolean;

		/**
		 **/
		public var metadataXslt : String = null;

		/**
		 **/
		public var metadataFilenameXslt : String = null;

		/**
		 **/
		public var flavorAssetFilenameXslt : String = null;

		/**
		 **/
		public var thumbnailAssetFilenameXslt : String = null;

		/**
		 **/
		public var assetFilenameXslt : String = null;

		/**
		 **/
		public var asperaPublicKey : String = null;

		/**
		 **/
		public var asperaPrivateKey : String = null;

		/**
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var sendMetadataAfterAssets : Boolean;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('host');
			arr.push('port');
			arr.push('basePath');
			arr.push('username');
			arr.push('password');
			arr.push('passphrase');
			arr.push('sftpPublicKey');
			arr.push('sftpPrivateKey');
			arr.push('disableMetadata');
			arr.push('metadataXslt');
			arr.push('metadataFilenameXslt');
			arr.push('flavorAssetFilenameXslt');
			arr.push('thumbnailAssetFilenameXslt');
			arr.push('assetFilenameXslt');
			arr.push('asperaPublicKey');
			arr.push('asperaPrivateKey');
			arr.push('sendMetadataAfterAssets');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			arr.push('protocol');
			return arr;
		}
	}
}
