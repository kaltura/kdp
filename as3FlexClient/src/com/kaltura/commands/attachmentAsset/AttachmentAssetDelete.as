package com.kaltura.commands.attachmentAsset
{
	import com.kaltura.delegates.attachmentAsset.AttachmentAssetDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class AttachmentAssetDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param attachmentAssetId String
		 **/
		public function AttachmentAssetDelete( attachmentAssetId : String )
		{
			service= 'attachment_attachmentasset';
			action= 'delete';

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
			delegate = new AttachmentAssetDeleteDelegate( this , config );
		}
	}
}
