package com.kaltura.commands.media
{
	import com.kaltura.delegates.media.MediaApproveReplaceDelegate;
	import com.kaltura.net.KalturaCall;

	public class MediaApproveReplace extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 **/
		public function MediaApproveReplace( entryId : String )
		{
			service= 'media';
			action= 'approveReplace';

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
			delegate = new MediaApproveReplaceDelegate( this , config );
		}
	}
}
