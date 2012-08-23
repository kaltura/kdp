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
	public dynamic class KalturaTVComDistributionProfile extends KalturaConfigurableDistributionProfile
	{
		/**
		 **/
		public var metadataProfileId : int = int.MIN_VALUE;

		/**
		 **/
		public var feedUrl : String = null;

		/**
		 **/
		public var feedTitle : String = null;

		/**
		 **/
		public var feedLink : String = null;

		/**
		 **/
		public var feedDescription : String = null;

		/**
		 **/
		public var feedLanguage : String = null;

		/**
		 **/
		public var feedCopyright : String = null;

		/**
		 **/
		public var feedImageTitle : String = null;

		/**
		 **/
		public var feedImageUrl : String = null;

		/**
		 **/
		public var feedImageLink : String = null;

		/**
		 **/
		public var feedImageWidth : int = int.MIN_VALUE;

		/**
		 **/
		public var feedImageHeight : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('metadataProfileId');
			arr.push('feedTitle');
			arr.push('feedLink');
			arr.push('feedDescription');
			arr.push('feedLanguage');
			arr.push('feedCopyright');
			arr.push('feedImageTitle');
			arr.push('feedImageUrl');
			arr.push('feedImageLink');
			arr.push('feedImageWidth');
			arr.push('feedImageHeight');
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
