package com.kaltura.commands.attachmentAsset
{
	import com.kaltura.vo.KalturaAttachmentAsset;
	import com.kaltura.delegates.attachmentAsset.AttachmentAssetUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class AttachmentAssetUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 * @param attachmentAsset KalturaAttachmentAsset
		 **/
		public function AttachmentAssetUpdate( id : String,attachmentAsset : KalturaAttachmentAsset )
		{
			service= 'attachment_attachmentasset';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(attachmentAsset, 'attachmentAsset');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new AttachmentAssetUpdateDelegate( this , config );
		}
	}
}
