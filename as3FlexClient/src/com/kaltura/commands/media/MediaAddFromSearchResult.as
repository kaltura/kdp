package com.kaltura.commands.media
{
	import com.kaltura.vo.KalturaMediaEntry;
	import com.kaltura.vo.KalturaSearchResult;
	import com.kaltura.delegates.media.MediaAddFromSearchResultDelegate;
	import com.kaltura.net.KalturaCall;

	public class MediaAddFromSearchResult extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param mediaEntry KalturaMediaEntry
		 * @param searchResult KalturaSearchResult
		 **/
		public function MediaAddFromSearchResult( mediaEntry : KalturaMediaEntry=null,searchResult : KalturaSearchResult=null )
		{
			if(mediaEntry== null)mediaEntry= new KalturaMediaEntry();
			if(searchResult== null)searchResult= new KalturaSearchResult();
			service= 'media';
			action= 'addFromSearchResult';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(mediaEntry, 'mediaEntry');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			keyValArr = kalturaObject2Arrays(searchResult, 'searchResult');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MediaAddFromSearchResultDelegate( this , config );
		}
	}
}
