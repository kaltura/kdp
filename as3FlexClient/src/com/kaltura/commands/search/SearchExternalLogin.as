package com.kaltura.commands.search
{
	import com.kaltura.delegates.search.SearchExternalLoginDelegate;
	import com.kaltura.net.KalturaCall;

	public class SearchExternalLogin extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param searchSource int
		 * @param userName String
		 * @param password String
		 **/
		public function SearchExternalLogin( searchSource : int,userName : String,password : String )
		{
			service= 'search';
			action= 'externalLogin';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('searchSource');
			valueArr.push(searchSource);
			keyArr.push('userName');
			valueArr.push(userName);
			keyArr.push('password');
			valueArr.push(password);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new SearchExternalLoginDelegate( this , config );
		}
	}
}
