package com.kaltura.commands.documents
{
	import com.kaltura.vo.KalturaDocumentEntry;
	import com.kaltura.delegates.documents.DocumentsAddFromEntryDelegate;
	import com.kaltura.net.KalturaCall;

	public class DocumentsAddFromEntry extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param sourceEntryId String
		 * @param documentEntry KalturaDocumentEntry
		 * @param sourceFlavorParamsId int
		 **/
		public function DocumentsAddFromEntry( sourceEntryId : String,documentEntry : KalturaDocumentEntry=null,sourceFlavorParamsId : int=undefined )
		{
			if(documentEntry== null)documentEntry= new KalturaDocumentEntry();
			service= 'document_documents';
			action= 'addFromEntry';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('sourceEntryId');
			valueArr.push(sourceEntryId);
 			keyValArr = kalturaObject2Arrays(documentEntry, 'documentEntry');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('sourceFlavorParamsId');
			valueArr.push(sourceFlavorParamsId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DocumentsAddFromEntryDelegate( this , config );
		}
	}
}
