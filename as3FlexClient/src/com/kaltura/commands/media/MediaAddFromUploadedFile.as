package com.kaltura.commands.media
{
	import com.kaltura.vo.KalturaMediaEntry;
	import com.kaltura.delegates.media.MediaAddFromUploadedFileDelegate;
	import com.kaltura.net.KalturaCall;

	public class MediaAddFromUploadedFile extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param mediaEntry KalturaMediaEntry
		 * @param uploadTokenId String
		 **/
		public function MediaAddFromUploadedFile( mediaEntry : KalturaMediaEntry,uploadTokenId : String )
		{
			service= 'media';
			action= 'addFromUploadedFile';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(mediaEntry, 'mediaEntry');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('uploadTokenId');
			valueArr.push(uploadTokenId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MediaAddFromUploadedFileDelegate( this , config );
		}
	}
}
