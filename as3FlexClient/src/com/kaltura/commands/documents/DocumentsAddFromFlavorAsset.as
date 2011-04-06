package com.kaltura.commands.documents
{
	import com.kaltura.vo.KalturaDocumentEntry;
	import com.kaltura.delegates.documents.DocumentsAddFromFlavorAssetDelegate;
	import com.kaltura.net.KalturaCall;

	public class DocumentsAddFromFlavorAsset extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param sourceFlavorAssetId String
		 * @param documentEntry KalturaDocumentEntry
		 **/
		public function DocumentsAddFromFlavorAsset( sourceFlavorAssetId : String,documentEntry : KalturaDocumentEntry=null )
		{
			if(documentEntry== null)documentEntry= new KalturaDocumentEntry();
			service= 'document_documents';
			action= 'addFromFlavorAsset';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('sourceFlavorAssetId');
			valueArr.push(sourceFlavorAssetId);
 			keyValArr = kalturaObject2Arrays(documentEntry, 'documentEntry');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DocumentsAddFromFlavorAssetDelegate( this , config );
		}
	}
}
