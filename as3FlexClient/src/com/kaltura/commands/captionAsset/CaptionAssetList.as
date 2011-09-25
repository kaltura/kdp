package com.kaltura.commands.captionAsset
{
	import com.kaltura.vo.KalturaAssetFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.captionAsset.CaptionAssetListDelegate;
	import com.kaltura.net.KalturaCall;

	public class CaptionAssetList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaAssetFilter
		 * @param pager KalturaFilterPager
		 **/
		public function CaptionAssetList( filter : KalturaAssetFilter=null,pager : KalturaFilterPager=null )
		{
			service= 'caption_captionasset';
			action= 'list';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			if (filter) { 
 			keyValArr = kalturaObject2Arrays(filter, 'filter');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			} 
 			if (pager) { 
 			keyValArr = kalturaObject2Arrays(pager, 'pager');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			} 
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new CaptionAssetListDelegate( this , config );
		}
	}
}
