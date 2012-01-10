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
	import com.kaltura.vo.KalturaPlayableEntry;

	[Bindable]
	public dynamic class KalturaMediaEntry extends KalturaPlayableEntry
	{
		/** 
		* 		* */ 
		public var mediaType : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var conversionQuality : String = null;

		/** 
		* 		* */ 
		public var sourceType : String = null;

		/** 
		* 		* */ 
		public var searchProviderType : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var searchProviderId : String = null;

		/** 
		* 		* */ 
		public var creditUserName : String = null;

		/** 
		* 		* */ 
		public var creditUrl : String = null;

		/** 
		* 		* */ 
		public var mediaDate : int = int.MIN_VALUE;

		/** 
		* The URL used for playback. This is not the download URL.		* */ 
		public var dataUrl : String = null;

		/** 
		* 		* */ 
		public var flavorParamsIds : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('creditUserName');
			arr.push('creditUrl');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			arr.push('mediaType');
			arr.push('conversionQuality');
			arr.push('sourceType');
			arr.push('searchProviderType');
			arr.push('searchProviderId');
			return arr;
		}

	}
}
