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
	import com.kaltura.vo.BaseFlexVo;

	[Bindable]
	public dynamic class KalturaBaseSyndicationFeed extends BaseFlexVo
	{
		/**
		 **/
		public var id : String = null;

		/**
		 **/
		public var feedUrl : String = null;

		/**
		 **/
		public var partnerId : int = int.MIN_VALUE;

		/**
		 * link a playlist that will set what content the feed will include
		 * if empty, all content will be included in feed
		 * 
		 **/
		public var playlistId : String = null;

		/**
		 * feed name
		 * 
		 **/
		public var name : String = null;

		/**
		 * feed status
		 * 
		 * @see com.kaltura.types.KalturaSyndicationFeedStatus
		 **/
		public var status : int = int.MIN_VALUE;

		/**
		 * feed type
		 * 
		 * @see com.kaltura.types.KalturaSyndicationFeedType
		 **/
		public var type : int = int.MIN_VALUE;

		/**
		 * Base URL for each video, on the partners site
		 * This is required by all syndication types.
		 * 
		 **/
		public var landingPage : String = null;

		/**
		 * Creation date as Unix timestamp (In seconds)
		 * 
		 **/
		public var createdAt : int = int.MIN_VALUE;

		/**
		 * allow_embed tells google OR yahoo weather to allow embedding the video on google OR yahoo video results
		 * or just to provide a link to the landing page.
		 * it is applied on the video-player_loc property in the XML (google)
		 * and addes media-player tag (yahoo)
		 * 
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var allowEmbed : Boolean;

		/**
		 * Select a uiconf ID as player skin to include in the kwidget url
		 * 
		 **/
		public var playerUiconfId : int = int.MIN_VALUE;

		/**
		 **/
		public var flavorParamId : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var transcodeExistingContent : Boolean;

		/**
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var addToDefaultConversionProfile : Boolean;

		/**
		 **/
		public var categories : String = null;

		/**
		 **/
		public var storageId : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaSyndicationFeedEntriesOrderBy
		 **/
		public var entriesOrderBy : String = null;

		/**
		 * Should enforce entitlement on feed entries
		 * 
		 * @see com.kaltura.types.kalturaBoolean
		 **/
		public var enforceEntitlement : Boolean;

		/**
		 * Set privacy context for search entries that assiged to private and public categories within a category privacy context.
		 * 
		 **/
		public var privacyContext : String = null;

		/**
		 * Update date as Unix timestamp (In seconds)
		 * 
		 **/
		public var updatedAt : int = int.MIN_VALUE;

		/** 
		 * a list of attributes which may be updated on this object 
		 **/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('playlistId');
			arr.push('name');
			arr.push('landingPage');
			arr.push('allowEmbed');
			arr.push('playerUiconfId');
			arr.push('flavorParamId');
			arr.push('transcodeExistingContent');
			arr.push('addToDefaultConversionProfile');
			arr.push('categories');
			arr.push('storageId');
			arr.push('entriesOrderBy');
			arr.push('enforceEntitlement');
			arr.push('privacyContext');
			return arr;
		}

		/** 
		 * a list of attributes which may only be inserted when initializing this object 
		 **/ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('type');
			return arr;
		}
	}
}
