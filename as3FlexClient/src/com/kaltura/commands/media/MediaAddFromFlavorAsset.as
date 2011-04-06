package com.kaltura.commands.media
{
	import com.kaltura.vo.KalturaMediaEntry;
	import com.kaltura.delegates.media.MediaAddFromFlavorAssetDelegate;
	import com.kaltura.net.KalturaCall;

	public class MediaAddFromFlavorAsset extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param sourceFlavorAssetId String
		 * @param mediaEntry KalturaMediaEntry
		 **/
		public function MediaAddFromFlavorAsset( sourceFlavorAssetId : String,mediaEntry : KalturaMediaEntry=null )
		{
			if(mediaEntry== null)mediaEntry= new KalturaMediaEntry();
			service= 'media';
			action= 'addFromFlavorAsset';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('sourceFlavorAssetId');
			valueArr.push(sourceFlavorAssetId);
 			keyValArr = kalturaObject2Arrays(mediaEntry, 'mediaEntry');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MediaAddFromFlavorAssetDelegate( this , config );
		}
	}
}
