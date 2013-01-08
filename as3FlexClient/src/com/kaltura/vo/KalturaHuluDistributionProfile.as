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
	public dynamic class KalturaHuluDistributionProfile extends KalturaConfigurableDistributionProfile
	{
		/**
		 **/
		public var sftpHost : String = null;

		/**
		 **/
		public var sftpLogin : String = null;

		/**
		 **/
		public var sftpPass : String = null;

		/**
		 **/
		public var seriesChannel : String = null;

		/**
		 **/
		public var seriesPrimaryCategory : String = null;

		/**
		 **/
		public var seriesAdditionalCategories : Array = null;

		/**
		 **/
		public var seasonNumber : String = null;

		/**
		 **/
		public var seasonSynopsis : String = null;

		/**
		 **/
		public var seasonTuneInInformation : String = null;

		/**
		 **/
		public var videoMediaType : String = null;

		/**
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var disableEpisodeNumberCustomValidation : Boolean;

		/**
		 * @see com.kaltura.types.KalturaDistributionProtocol
		 **/
		public var protocol : int = int.MIN_VALUE;

		/**
		 **/
		public var asperaHost : String = null;

		/**
		 **/
		public var asperaLogin : String = null;

		/**
		 **/
		public var asperaPass : String = null;

		/**
		 **/
		public var port : int = int.MIN_VALUE;

		/**
		 **/
		public var passphrase : String = null;

		/**
		 **/
		public var asperaPublicKey : String = null;

		/**
		 **/
		public var asperaPrivateKey : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('sftpHost');
			arr.push('sftpLogin');
			arr.push('sftpPass');
			arr.push('seriesChannel');
			arr.push('seriesPrimaryCategory');
			arr.push('seriesAdditionalCategories');
			arr.push('seasonNumber');
			arr.push('seasonSynopsis');
			arr.push('seasonTuneInInformation');
			arr.push('videoMediaType');
			arr.push('disableEpisodeNumberCustomValidation');
			arr.push('protocol');
			arr.push('asperaHost');
			arr.push('asperaLogin');
			arr.push('asperaPass');
			arr.push('port');
			arr.push('passphrase');
			arr.push('asperaPublicKey');
			arr.push('asperaPrivateKey');
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
