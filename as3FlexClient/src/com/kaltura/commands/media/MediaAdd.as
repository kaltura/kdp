package com.kaltura.commands.media
{
	import com.kaltura.vo.KalturaMediaEntry;
	import com.kaltura.delegates.media.MediaAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class MediaAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entry KalturaMediaEntry
		 **/
		public function MediaAdd( entry : KalturaMediaEntry )
		{
			service= 'media';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(entry, 'entry');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MediaAddDelegate( this , config );
		}
	}
}
