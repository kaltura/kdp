package com.kaltura.commands.documents
{
	import com.kaltura.vo.KalturaDocumentEntry;
	import com.kaltura.delegates.documents.DocumentsAddFromUploadedFileDelegate;
	import com.kaltura.net.KalturaCall;

	public class DocumentsAddFromUploadedFile extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param documentEntry KalturaDocumentEntry
		 * @param uploadTokenId String
		 **/
		public function DocumentsAddFromUploadedFile( documentEntry : KalturaDocumentEntry,uploadTokenId : String )
		{
			service= 'document_documents';
			action= 'addFromUploadedFile';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(documentEntry, 'documentEntry');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('uploadTokenId');
			valueArr.push(uploadTokenId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DocumentsAddFromUploadedFileDelegate( this , config );
		}
	}
}
