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
		* 		* */ 
		public var username : String = null;

		/** 
		* 		* */ 
		public var notificationEmail : String = null;

		/** 
		* 		* */ 
		public var sftpHost : String = null;

		/** 
		* 		* */ 
		public var sftpLogin : String = null;

		/** 
		* 		* */ 
		public var sftpPublicKey : String = null;

		/** 
		* 		* */ 
		public var sftpPrivateKey : String = null;

		/** 
		* 		* */ 
		public var sftpBaseDir : String = null;

		/** 
		* 		* */ 
		public var ownerName : String = null;

		/** 
		* 		* */ 
		public var defaultCategory : String = null;

		/** 
		* 		* */ 
		public var allowComments : String = null;

		/** 
		* 		* */ 
		public var allowEmbedding : String = null;

		/** 
		* 		* */ 
		public var allowRatings : String = null;

		/** 
		* 		* */ 
		public var allowResponses : String = null;

		/** 
		* 		* */ 
		public var commercialPolicy : String = null;

		/** 
		* 		* */ 
		public var ugcPolicy : String = null;

		/** 
		* 		* */ 
		public var target : String = null;

		/** 
		* 		* */ 
		public var adServerPartnerId : String = null;

		/** 
		* 		* */ 
		public var enableAdServer : Boolean;

		/** 
		* 		* */ 
		public var allowPreRollAds : Boolean;

		/** 
		* 		* */ 
		public var allowPostRollAds : Boolean;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('username');
			arr.push('notificationEmail');
			arr.push('sftpHost');
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
