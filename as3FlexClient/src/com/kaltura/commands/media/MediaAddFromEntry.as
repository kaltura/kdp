package com.kaltura.commands.media
{
	import com.kaltura.vo.KalturaMediaEntry;
	import com.kaltura.delegates.media.MediaAddFromEntryDelegate;
	import com.kaltura.net.KalturaCall;

	public class MediaAddFromEntry extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param sourceEntryId String
		 * @param mediaEntry KalturaMediaEntry
		 * @param sourceFlavorParamsId int
		 **/
		public function MediaAddFromEntry( sourceEntryId : String,mediaEntry : KalturaMediaEntry=null,sourceFlavorParamsId : int=undefined )
		{
			if(mediaEntry== null)mediaEntry= new KalturaMediaEntry();
			service= 'media';
			action= 'addFromEntry';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('sourceEntryId');
			valueArr.push(sourceEntryId);
 			keyValArr = kalturaObject2Arrays(mediaEntry, 'mediaEntry');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('sourceFlavorParamsId');
			valueArr.push(sourceFlavorParamsId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MediaAddFromEntryDelegate( this , config );
		}
	}
}
