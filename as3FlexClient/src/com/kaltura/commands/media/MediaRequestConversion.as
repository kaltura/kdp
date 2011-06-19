package com.kaltura.commands.media
{
	import com.kaltura.delegates.media.MediaRequestConversionDelegate;
	import com.kaltura.net.KalturaCall;

	public class MediaRequestConversion extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param fileFormat String
		 **/
		public function MediaRequestConversion( entryId : String,fileFormat : String )
		{
			service= 'media';
			action= 'requestConversion';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			keyArr.push('fileFormat');
			valueArr.push(fileFormat);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MediaRequestConversionDelegate( this , config );
		}
	}
}
