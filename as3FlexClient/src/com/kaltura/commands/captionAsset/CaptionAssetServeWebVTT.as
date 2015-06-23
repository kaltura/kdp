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
package com.kaltura.commands.captionAsset
{
	import com.kaltura.delegates.captionAsset.CaptionAssetServeWebVTTDelegate;
	import com.kaltura.net.KalturaCall;

	/**
	* Serves caption by its id converting it to segmented WebVTT
	* 
	**/
	public class CaptionAssetServeWebVTT extends KalturaCall
	{
		public var filterFields : String;
		
		/**
		* @param captionAssetId String
		* @param segmentDuration int
		* @param segmentIndex int
		* @param localTimestamp int
		**/
		public function CaptionAssetServeWebVTT( captionAssetId : String,segmentDuration : int=30,segmentIndex : int=int.MIN_VALUE,localTimestamp : int=10000 )
		{
			service= 'caption_captionasset';
			action= 'serveWebVTT';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('captionAssetId');
			valueArr.push(captionAssetId);
			keyArr.push('segmentDuration');
			valueArr.push(segmentDuration);
			keyArr.push('segmentIndex');
			valueArr.push(segmentIndex);
			keyArr.push('localTimestamp');
			valueArr.push(localTimestamp);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new CaptionAssetServeWebVTTDelegate( this , config );
		}
	}
}
