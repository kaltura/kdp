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
package com.kaltura.commands.mixing
{
	import com.kaltura.delegates.mixing.MixingGetMixesByMediaIdDelegate;
	import com.kaltura.net.KalturaCall;

	/**
	 * Get the mixes in which the media entry is included
	 * 
	 **/
	public class MixingGetMixesByMediaId extends KalturaCall
	{
		public var filterFields : String;
		
		/**
		 * @param mediaEntryId String
		 **/
		public function MixingGetMixesByMediaId( mediaEntryId : String )
		{
			service= 'mixing';
			action= 'getMixesByMediaId';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('mediaEntryId');
			valueArr.push(mediaEntryId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MixingGetMixesByMediaIdDelegate( this , config );
		}
	}
}
