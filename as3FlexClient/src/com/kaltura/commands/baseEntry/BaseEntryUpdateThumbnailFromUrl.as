package com.kaltura.commands.baseEntry
{
	import com.kaltura.delegates.baseEntry.BaseEntryUpdateThumbnailFromUrlDelegate;
	import com.kaltura.net.KalturaCall;

	public class BaseEntryUpdateThumbnailFromUrl extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param url String
		 **/
		public function BaseEntryUpdateThumbnailFromUrl( entryId : String,url : String )
		{
			service= 'baseentry';
			action= 'updateThumbnailFromUrl';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			keyArr.push('url');
			valueArr.push(url);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new BaseEntryUpdateThumbnailFromUrlDelegate( this , config );
		}
	}
}
