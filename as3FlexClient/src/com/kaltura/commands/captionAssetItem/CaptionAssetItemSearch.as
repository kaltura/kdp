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
package com.kaltura.commands.captionAssetItem
{
	import com.kaltura.vo.KalturaBaseEntryFilter;
	import com.kaltura.vo.KalturaCaptionAssetItemFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.captionAssetItem.CaptionAssetItemSearchDelegate;
	import com.kaltura.net.KalturaCall;

	/**
	 * Search caption asset items by filter, pager and free text
	 * 
	 **/
	public class CaptionAssetItemSearch extends KalturaCall
	{
		public var filterFields : String;
		
		/**
		 * @param entryFilter KalturaBaseEntryFilter
		 * @param captionAssetItemFilter KalturaCaptionAssetItemFilter
		 * @param captionAssetItemPager KalturaFilterPager
		 **/
		public function CaptionAssetItemSearch( entryFilter : KalturaBaseEntryFilter=null,captionAssetItemFilter : KalturaCaptionAssetItemFilter=null,captionAssetItemPager : KalturaFilterPager=null )
		{
			service= 'captionsearch_captionassetitem';
			action= 'search';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			if (entryFilter) { 
 			keyValArr = kalturaObject2Arrays(entryFilter, 'entryFilter');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			} 
 			if (captionAssetItemFilter) { 
 			keyValArr = kalturaObject2Arrays(captionAssetItemFilter, 'captionAssetItemFilter');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			} 
 			if (captionAssetItemPager) { 
 			keyValArr = kalturaObject2Arrays(captionAssetItemPager, 'captionAssetItemPager');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			} 
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new CaptionAssetItemSearchDelegate( this , config );
		}
	}
}
