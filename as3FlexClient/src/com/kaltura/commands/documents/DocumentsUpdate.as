package com.kaltura.commands.documents
{
	import com.kaltura.vo.KalturaDocumentEntry;
	import com.kaltura.delegates.documents.DocumentsUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class DocumentsUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param documentEntry KalturaDocumentEntry
		 **/
		public function DocumentsUpdate( entryId : String,documentEntry : KalturaDocumentEntry )
		{
			service= 'document_documents';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
 			keyValArr = kalturaObject2Arrays(documentEntry, 'documentEntry');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DocumentsUpdateDelegate( this , config );
		}
	}
}
