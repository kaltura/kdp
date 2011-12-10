package com.kaltura.commands.media
{
	import com.kaltura.vo.KalturaMediaEntry;
	import com.kaltura.delegates.media.MediaAddFromUrlDelegate;
	import com.kaltura.net.KalturaCall;

	public class MediaAddFromUrl extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param mediaEntry KalturaMediaEntry
		 * @param url String
		 **/
		public function MediaAddFromUrl( mediaEntry : KalturaMediaEntry,url : String )
		{
			service= 'media';
			action= 'addFromUrl';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(mediaEntry, 'mediaEntry');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('url');
			valueArr.push(url);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MediaAddFromUrlDelegate( this , config );
		}
	}
}
