package com.kaltura.commands.attachmentAsset
{
	import com.kaltura.vo.KalturaContentResource;
	import com.kaltura.delegates.attachmentAsset.AttachmentAssetSetContentDelegate;
	import com.kaltura.net.KalturaCall;

	public class AttachmentAssetSetContent extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 * @param contentResource KalturaContentResource
		 **/
		public function AttachmentAssetSetContent( id : String,contentResource : KalturaContentResource )
		{
			service= 'attachment_attachmentasset';
			action= 'setContent';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(contentResource, 'contentResource');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new AttachmentAssetSetContentDelegate( this , config );
		}
	}
}
