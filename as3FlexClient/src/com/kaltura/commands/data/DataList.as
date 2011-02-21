package com.kaltura.commands.data
{
	import com.kaltura.vo.KalturaDataEntryFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.data.DataListDelegate;
	import com.kaltura.net.KalturaCall;

	public class DataList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaDataEntryFilter
		 * @param pager KalturaFilterPager
		 **/
		public function DataList( filter : KalturaDataEntryFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaDataEntryFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'data';
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
			delegate = new DataListDelegate( this , config );
		}
	}
}
