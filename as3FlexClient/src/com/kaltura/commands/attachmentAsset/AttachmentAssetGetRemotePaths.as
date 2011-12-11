package com.kaltura.commands.attachmentAsset
{
	import com.kaltura.delegates.attachmentAsset.AttachmentAssetGetRemotePathsDelegate;
	import com.kaltura.net.KalturaCall;

	public class AttachmentAssetGetRemotePaths extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 **/
		public function AttachmentAssetGetRemotePaths( id : String )
		{
			service= 'attachment_attachmentasset';
			action= 'getRemotePaths';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new AttachmentAssetGetRemotePathsDelegate( this , config );
		}
	}
}
