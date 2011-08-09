package com.kaltura.commands.media
{
	import com.kaltura.vo.KalturaMediaEntry;
	import com.kaltura.delegates.media.MediaAddFromRecordedWebcamDelegate;
	import com.kaltura.net.KalturaCall;

	public class MediaAddFromRecordedWebcam extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param mediaEntry KalturaMediaEntry
		 * @param webcamTokenId String
		 **/
		public function MediaAddFromRecordedWebcam( mediaEntry : KalturaMediaEntry,webcamTokenId : String )
		{
			service= 'media';
			action= 'addFromRecordedWebcam';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(mediaEntry, 'mediaEntry');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('webcamTokenId');
			valueArr.push(webcamTokenId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MediaAddFromRecordedWebcamDelegate( this , config );
		}
	}
}
