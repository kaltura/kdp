package com.kaltura.commands.attachmentAsset
{
	import com.kaltura.delegates.attachmentAsset.AttachmentAssetGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class AttachmentAssetGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param attachmentAssetId String
		 **/
		public function AttachmentAssetGet( attachmentAssetId : String )
		{
			service= 'attachment_attachmentasset';
			action= 'get';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('attachmentAssetId');
			valueArr.push(attachmentAssetId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new AttachmentAssetGetDelegate( this , config );
		}
	}
}
