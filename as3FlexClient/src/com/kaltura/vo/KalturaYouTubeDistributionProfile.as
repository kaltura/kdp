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
	public dynamic class KalturaYouTubeDistributionProfile extends KalturaConfigurableDistributionProfile
	{
		/**
		 * @see com.kaltura.types.KalturaYouTubeDistributionFeedSpecVersion
		 **/
		public var feedSpecVersion : String = null;

		/**
		 **/
		public var username : String = null;

		/**
		 **/
		public var notificationEmail : String = null;

		/**
		 **/
		public var sftpHost : String = null;

		/**
		 **/
		public var sftpPort : int = int.MIN_VALUE;

		/**
		 **/
		public var sftpLogin : String = null;

		/**
		 **/
		public var sftpPublicKey : String = null;

		/**
		 **/
		public var sftpPrivateKey : String = null;

		/**
		 **/
		public var sftpBaseDir : String = null;

		/**
		 **/
		public var ownerName : String = null;

		/**
		 **/
		public var defaultCategory : String = null;

		/**
		 **/
		public var allowComments : String = null;

		/**
		 **/
		public var allowEmbedding : String = null;

		/**
		 **/
		public var allowRatings : String = null;

		/**
		 **/
		public var allowResponses : String = null;

		/**
		 **/
		public var commercialPolicy : String = null;

		/**
		 **/
		public var ugcPolicy : String = null;

		/**
		 **/
		public var target : String = null;

		/**
		 **/
		public var adServerPartnerId : String = null;

		/**
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var enableAdServer : Boolean;

		/**
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var allowPreRollAds : Boolean;

		/**
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var allowPostRollAds : Boolean;

		/**
		 **/
		public var strict : String = null;

		/**
		 **/
		public var overrideManualEdits : String = null;

		/**
		 **/
		public var urgentReference : String = null;

		/**
		 **/
		public var allowSyndication : String = null;

		/**
		 **/
		public var hideViewCount : String = null;

		/**
		 **/
		public var allowAdsenseForVideo : String = null;

		/**
		 **/
		public var allowInvideo : String = null;

		/**
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var allowMidRollAds : Boolean;

		/**
		 **/
		public var instreamStandard : String = null;

		/**
		 **/
		public var instreamTrueview : String = null;

		/**
		 **/
		public var claimType : String = null;

		/**
		 **/
		public var blockOutsideOwnership : String = null;

		/**
		 **/
		public var captionAutosync : String = null;

		/**
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var deleteReference : Boolean;

		/**
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var releaseClaims : Boolean;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('feedSpecVersion');
			arr.push('username');
			arr.push('notificationEmail');
			arr.push('sftpHost');
			arr.push('sftpPort');
			arr.push('sftpLogin');
			arr.push('sftpPublicKey');
			arr.push('sftpPrivateKey');
			arr.push('sftpBaseDir');
			arr.push('ownerName');
			arr.push('defaultCategory');
			arr.push('allowComments');
			arr.push('allowEmbedding');
			arr.push('allowRatings');
			arr.push('allowResponses');
			arr.push('commercialPolicy');
			arr.push('ugcPolicy');
			arr.push('target');
			arr.push('adServerPartnerId');
			arr.push('enableAdServer');
			arr.push('allowPreRollAds');
			arr.push('allowPostRollAds');
			arr.push('strict');
			arr.push('overrideManualEdits');
			arr.push('urgentReference');
			arr.push('allowSyndication');
			arr.push('hideViewCount');
			arr.push('allowAdsenseForVideo');
			arr.push('allowInvideo');
			arr.push('allowMidRollAds');
			arr.push('instreamStandard');
			arr.push('instreamTrueview');
			arr.push('claimType');
			arr.push('blockOutsideOwnership');
			arr.push('captionAutosync');
			arr.push('deleteReference');
			arr.push('releaseClaims');
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
