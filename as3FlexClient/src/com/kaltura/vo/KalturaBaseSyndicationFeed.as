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
		* 		* */ 
		public var id : String = null;

		/** 
		* 		* */ 
		public var feedUrl : String = null;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var playlistId : String = null;

		/** 
		* 		* */ 
		public var name : String = null;

		/** 
		* 		* */ 
		public var status : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var type : int = int.MIN_VALUE;

		/** 
		* This is required by all syndication types.		* */ 
		public var landingPage : String = null;

		/** 
		* 		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* or just to provide a link to the landing page.		* */ 
		public var allowEmbed : Boolean;

		/** 
		* 		* */ 
		public var playerUiconfId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var flavorParamId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var transcodeExistingContent : Boolean;

		/** 
		* 		* */ 
		public var addToDefaultConversionProfile : Boolean;

		/** 
		* 		* */ 
		public var categories : String = null;

		/** 
		* 		* */ 
		public var storageId : int = int.MIN_VALUE;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
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
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		* */ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('type');
			return arr;
		}

	}
}
