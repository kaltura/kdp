package com.kaltura.commands.uploadToken
{
	import com.kaltura.vo.KalturaUploadTokenFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.uploadToken.UploadTokenListDelegate;
	import com.kaltura.net.KalturaCall;

	public class UploadTokenList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaUploadTokenFilter
		 * @param pager KalturaFilterPager
		 **/
		public function UploadTokenList( filter : KalturaUploadTokenFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaUploadTokenFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'uploadtoken';
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
			delegate = new UploadTokenListDelegate( this , config );
		}
	}
}
