package com.kaltura.commands.thumbAsset
{
	import com.kaltura.vo.KalturaAssetFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.thumbAsset.ThumbAssetListDelegate;
	import com.kaltura.net.KalturaCall;

	public class ThumbAssetList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaAssetFilter
		 * @param pager KalturaFilterPager
		 **/
		public function ThumbAssetList( filter : KalturaAssetFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaAssetFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'thumbasset';
			action= 'list';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(filter, 'filter');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			keyValArr = kalturaObject2Arrays(pager, 'pager');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ThumbAssetListDelegate( this , config );
		}
	}
}
