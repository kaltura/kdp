package com.kaltura.commands.document
{
	import com.kaltura.vo.KalturaDocumentEntry;
	import com.kaltura.delegates.document.DocumentUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class DocumentUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param documentEntry KalturaDocumentEntry
		 **/
		public function DocumentUpdate( entryId : String,documentEntry : KalturaDocumentEntry )
		{
			service= 'document';
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
			delegate = new DocumentUpdateDelegate( this , config );
		}
	}
}
