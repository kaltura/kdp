package com.kaltura.commands.document
{
	import com.kaltura.vo.KalturaDocumentEntry;
	import com.kaltura.delegates.document.DocumentAddFromFlavorAssetDelegate;
	import com.kaltura.net.KalturaCall;

	public class DocumentAddFromFlavorAsset extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param sourceFlavorAssetId String
		 * @param documentEntry KalturaDocumentEntry
		 **/
		public function DocumentAddFromFlavorAsset( sourceFlavorAssetId : String,documentEntry : KalturaDocumentEntry=null )
		{
			service= 'document';
			action= 'addFromFlavorAsset';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('sourceFlavorAssetId');
			valueArr.push(sourceFlavorAssetId);
 			if (documentEntry) { 
 			keyValArr = kalturaObject2Arrays(documentEntry, 'documentEntry');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			} 
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DocumentAddFromFlavorAssetDelegate( this , config );
		}
	}
}
