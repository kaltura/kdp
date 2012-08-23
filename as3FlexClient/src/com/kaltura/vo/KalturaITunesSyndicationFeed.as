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
	import com.kaltura.vo.KalturaBaseSyndicationFeed;

	[Bindable]
	public dynamic class KalturaITunesSyndicationFeed extends KalturaBaseSyndicationFeed
	{
		/**
		 * feed description
		 * 
		 **/
		public var feedDescription : String = null;

		/**
		 * feed language
		 * 
		 **/
		public var language : String = null;

		/**
		 * feed landing page (i.e publisher website)
		 * 
		 **/
		public var feedLandingPage : String = null;

		/**
		 * author/publisher name
		 * 
		 **/
		public var ownerName : String = null;

		/**
		 * publisher email
		 * 
		 **/
		public var ownerEmail : String = null;

		/**
		 * podcast thumbnail
		 * 
		 **/
		public var feedImageUrl : String = null;

		/**
		 * @see com.kaltura.types.KalturaITunesSyndicationFeedCategories
		 **/
		public var category : String = null;

		/**
		 * @see com.kaltura.types.KalturaITunesSyndicationFeedAdultValues
		 **/
		public var adultContent : String = null;

		/**
		 **/
		public var feedAuthor : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('feedDescription');
			arr.push('language');
			arr.push('feedLandingPage');
			arr.push('ownerName');
			arr.push('ownerEmail');
			arr.push('feedImageUrl');
			arr.push('adultContent');
			arr.push('feedAuthor');
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
