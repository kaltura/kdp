package com.kaltura.commands.media
{
	import com.kaltura.delegates.media.MediaCancelReplaceDelegate;
	import com.kaltura.net.KalturaCall;

	public class MediaCancelReplace extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 **/
		public function MediaCancelReplace( entryId : String )
		{
			service= 'media';
			action= 'cancelReplace';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MediaCancelReplaceDelegate( this , config );
		}
	}
}
