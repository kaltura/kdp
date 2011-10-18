package com.kaltura.commands.media
{
	import com.kaltura.delegates.media.MediaApproveDelegate;
	import com.kaltura.net.KalturaCall;

	public class MediaApprove extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 **/
		public function MediaApprove( entryId : String )
		{
			service= 'media';
			action= 'approve';

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
			delegate = new MediaApproveDelegate( this , config );
		}
	}
}
