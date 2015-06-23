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
package com.kaltura.commands.drmProfile
{
	import com.kaltura.delegates.drmProfile.DrmProfileGetByProviderDelegate;
	import com.kaltura.net.KalturaCall;

	/**
	* Retrieve a KalturaDrmProfile object by provider, if no specific profile defined return default profile
	* 
	**/
	public class DrmProfileGetByProvider extends KalturaCall
	{
		public var filterFields : String;
		
		/**
		* @param provider String
		**/
		public function DrmProfileGetByProvider( provider : String )
		{
			service= 'drm_drmprofile';
			action= 'getByProvider';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('provider');
			valueArr.push(provider);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DrmProfileGetByProviderDelegate( this , config );
		}
	}
}
