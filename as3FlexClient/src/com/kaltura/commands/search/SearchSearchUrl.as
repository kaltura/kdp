package com.kaltura.commands.search
{
	import com.kaltura.delegates.search.SearchSearchUrlDelegate;
	import com.kaltura.net.KalturaCall;

	public class SearchSearchUrl extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param mediaType int
		 * @param url String
		 **/
		public function SearchSearchUrl( mediaType : int,url : String )
		{
			service= 'search';
			action= 'searchUrl';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('mediaType');
			valueArr.push(mediaType);
			keyArr.push('url');
			valueArr.push(url);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new SearchSearchUrlDelegate( this , config );
		}
	}
}
