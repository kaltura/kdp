package com.kaltura.commands.media
{
	import com.kaltura.vo.KalturaMediaEntry;
	import com.kaltura.delegates.media.MediaAddFromBulkDelegate;
	import com.kaltura.net.KalturaCall;

	public class MediaAddFromBulk extends KalturaCall
	{
		public var filterFields : String;
		public function MediaAddFromBulk( mediaEntry : KalturaMediaEntry,url : String,bulkUploadId : int )
		{
			service= 'media';
			action= 'addFromBulk';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(mediaEntry,'mediaEntry');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			keyArr.push( 'url' );
			valueArr.push( url );
			keyArr.push( 'bulkUploadId' );
			valueArr.push( bulkUploadId );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new MediaAddFromBulkDelegate( this , config );
		}
	}
}
