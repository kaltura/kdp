package com.kaltura.commands.attachmentAsset
{
	import com.kaltura.vo.KalturaAssetFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.attachmentAsset.AttachmentAssetListDelegate;
	import com.kaltura.net.KalturaCall;

	public class AttachmentAssetList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaAssetFilter
		 * @param pager KalturaFilterPager
		 **/
		public function AttachmentAssetList( filter : KalturaAssetFilter=null,pager : KalturaFilterPager=null )
		{
			service= 'attachment_attachmentasset';
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
			delegate = new AttachmentAssetListDelegate( this , config );
		}
	}
}
