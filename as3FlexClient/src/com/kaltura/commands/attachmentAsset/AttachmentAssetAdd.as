package com.kaltura.commands.attachmentAsset
{
	import com.kaltura.vo.KalturaAttachmentAsset;
	import com.kaltura.delegates.attachmentAsset.AttachmentAssetAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class AttachmentAssetAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param attachmentAsset KalturaAttachmentAsset
		 **/
		public function AttachmentAssetAdd( entryId : String,attachmentAsset : KalturaAttachmentAsset )
		{
			service= 'attachment_attachmentasset';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
 			keyValArr = kalturaObject2Arrays(attachmentAsset, 'attachmentAsset');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new AttachmentAssetAddDelegate( this , config );
		}
	}
}
