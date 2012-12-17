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
package com.kaltura.commands.playlist
{
	import com.kaltura.delegates.playlist.PlaylistExecuteFromFiltersDelegate;
	import com.kaltura.net.KalturaCall;

	/**
	 * Revrieve playlist for playing purpose, based on media entry filters
	 * 
	 **/
	public class PlaylistExecuteFromFilters extends KalturaCall
	{
		public var filterFields : String;
		
		/**
		 * @param filters Array
		 * @param totalResults int
		 * @param detailed String
		 **/
		public function PlaylistExecuteFromFilters( filters : Array,totalResults : int,detailed : String='' )
		{
			service= 'playlist';
			action= 'executeFromFilters';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = extractArray(filters,'filters');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('totalResults');
			valueArr.push(totalResults);
			keyArr.push('detailed');
			valueArr.push(detailed);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new PlaylistExecuteFromFiltersDelegate( this , config );
		}
	}
}
