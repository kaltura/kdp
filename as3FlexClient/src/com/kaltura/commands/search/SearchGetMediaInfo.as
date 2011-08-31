package com.kaltura.commands.search
{
	import com.kaltura.vo.KalturaSearchResult;
	import com.kaltura.delegates.search.SearchGetMediaInfoDelegate;
	import com.kaltura.net.KalturaCall;

	public class SearchGetMediaInfo extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param searchResult KalturaSearchResult
		 **/
		public function SearchGetMediaInfo( searchResult : KalturaSearchResult )
		{
			service= 'search';
			action= 'getMediaInfo';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(searchResult, 'searchResult');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new SearchGetMediaInfoDelegate( this , config );
		}
	}
}
