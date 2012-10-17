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
package com.kaltura.commands.search
{
	import com.kaltura.delegates.search.SearchSearchUrlDelegate;
	import com.kaltura.net.KalturaCall;

	/**
	 * Search for media given a specific URL
	 * Kaltura supports a searchURL action on some of the media providers.
	 * This action will return a KalturaSearchResult object based on a given URL (assuming the media provider is supported)
	 * 
	 **/
	public class SearchSearchUrl extends KalturaCall
	{
		public var filterFields : String;
		
		/**
		 * @param mediaType int
		 * @param url String
		 **/
		public function SearchSearchUrl( mediaType : int,url : String )
		{
			service= 'search';
			action= 'searchUrl';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('mediaType');
			valueArr.push(mediaType);
			keyArr.push('url');
			valueArr.push(url);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new SearchSearchUrlDelegate( this , config );
		}
	}
}
