package com.kaltura.commands.baseEntry
{
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.baseEntry.BaseEntryListFlagsDelegate;
	import com.kaltura.net.KalturaCall;

	public class BaseEntryListFlags extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param pager KalturaFilterPager
		 **/
		public function BaseEntryListFlags( entryId : String,pager : KalturaFilterPager=null )
		{
			if(pager== null)pager= new KalturaFilterPager();
			service= 'baseentry';
			action= 'listFlags';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
 			keyValArr = kalturaObject2Arrays(pager, 'pager');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new BaseEntryListFlagsDelegate( this , config );
		}
	}
}
