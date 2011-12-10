package com.kaltura.commands.attachmentAsset
{
	import com.kaltura.delegates.attachmentAsset.AttachmentAssetGetDownloadUrlDelegate;
	import com.kaltura.net.KalturaCall;

	public class AttachmentAssetGetDownloadUrl extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 * @param useCdn Boolean
		 **/
		public function AttachmentAssetGetDownloadUrl( id : String,useCdn : Boolean=false )
		{
			service= 'attachment_attachmentasset';
			action= 'getDownloadUrl';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			keyArr.push('useCdn');
			valueArr.push(useCdn);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new AttachmentAssetGetDownloadUrlDelegate( this , config );
		}
	}
}
