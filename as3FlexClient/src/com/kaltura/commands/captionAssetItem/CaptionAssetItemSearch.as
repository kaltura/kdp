package com.kaltura.commands.captionAssetItem
{
	import com.kaltura.vo.KalturaBaseEntryFilter;
	import com.kaltura.vo.KalturaCaptionAssetItemFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.captionAssetItem.CaptionAssetItemSearchDelegate;
	import com.kaltura.net.KalturaCall;

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
