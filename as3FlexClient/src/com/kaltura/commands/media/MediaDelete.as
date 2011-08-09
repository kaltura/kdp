package com.kaltura.commands.media
{
	import com.kaltura.delegates.media.MediaDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class MediaDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 **/
		public function MediaDelete( entryId : String )
		{
			service= 'media';
			action= 'delete';

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
			delegate = new MediaDeleteDelegate( this , config );
		}
	}
}
