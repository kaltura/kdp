package com.kaltura.commands.search
{
	import com.kaltura.vo.KalturaSearch;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.search.SearchSearchDelegate;
	import com.kaltura.net.KalturaCall;

	public class SearchSearch extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param search KalturaSearch
		 * @param pager KalturaFilterPager
		 **/
		public function SearchSearch( search : KalturaSearch,pager : KalturaFilterPager=null )
		{
			if(pager== null)pager= new KalturaFilterPager();
			service= 'search';
			action= 'search';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(search, 'search');
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
			delegate = new SearchSearchDelegate( this , config );
		}
	}
}
