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
package com.kaltura.commands.metadataProfile
{
	import com.kaltura.vo.KalturaMetadataProfile;
	import com.kaltura.delegates.metadataProfile.MetadataProfileAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataProfileAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param metadataProfile KalturaMetadataProfile
		 * @param xsdData String
		 * @param viewsData String
		 **/
		public function MetadataProfileAdd( metadataProfile : KalturaMetadataProfile,xsdData : String,viewsData : String = null )
		{
			service= 'metadata_metadataprofile';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(metadataProfile, 'metadataProfile');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('xsdData');
			valueArr.push(xsdData);
			keyArr.push('viewsData');
			valueArr.push(viewsData);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MetadataProfileAddDelegate( this , config );
		}
	}
}
