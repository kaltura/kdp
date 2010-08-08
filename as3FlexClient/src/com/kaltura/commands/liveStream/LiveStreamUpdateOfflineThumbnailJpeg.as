package com.kaltura.commands.liveStream
{
	import com.kaltura.vo.File;
	import com.kaltura.delegates.liveStream.LiveStreamUpdateOfflineThumbnailJpegDelegate;
	import com.kaltura.net.KalturaCall;

	public class LiveStreamUpdateOfflineThumbnailJpeg extends KalturaCall
	{
		public var filterFields : String;
		public function LiveStreamUpdateOfflineThumbnailJpeg( entryId : String,fileData : file )
		{
			service= 'livestream';
			action= 'updateOfflineThumbnailJpeg';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'entryId' );
			valueArr.push( entryId );
 			keyValArr = kalturaObject2Arrays(fileData,'fileData');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new LiveStreamUpdateOfflineThumbnailJpegDelegate( this , config );
		}
	}
}
