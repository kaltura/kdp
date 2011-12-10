package com.kaltura.commands.attachmentAsset
{
	import com.kaltura.delegates.attachmentAsset.AttachmentAssetGetUrlDelegate;
	import com.kaltura.net.KalturaCall;

	public class AttachmentAssetGetUrl extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 * @param storageId int
		 **/
		public function AttachmentAssetGetUrl( id : String,storageId : int=int.MIN_VALUE )
		{
			service= 'attachment_attachmentasset';
			action= 'getUrl';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			keyArr.push('storageId');
			valueArr.push(storageId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new AttachmentAssetGetUrlDelegate( this , config );
		}
	}
}
