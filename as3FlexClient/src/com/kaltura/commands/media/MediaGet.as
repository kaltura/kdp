package com.kaltura.commands.media
{
	import com.kaltura.delegates.media.MediaGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class MediaGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param version int
		 **/
		public function MediaGet( entryId : String,version : int=-1 )
		{
			service= 'media';
			action= 'get';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			keyArr.push('version');
			valueArr.push(version);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MediaGetDelegate( this , config );
		}
	}
}
