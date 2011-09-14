package com.kaltura.commands.bulkUpload
{
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.bulkUpload.BulkUploadListDelegate;
	import com.kaltura.net.KalturaCall;

	public class BulkUploadList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param pager KalturaFilterPager
		 **/
		public function BulkUploadList( pager : KalturaFilterPager=null )
		{
			if(pager== null)pager= new KalturaFilterPager();
			service= 'bulkupload';
			action= 'list';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(pager, 'pager');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new BulkUploadListDelegate( this , config );
		}
	}
}
