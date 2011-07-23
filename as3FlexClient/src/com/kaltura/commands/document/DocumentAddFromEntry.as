package com.kaltura.commands.document
{
	import com.kaltura.vo.KalturaDocumentEntry;
	import com.kaltura.delegates.document.DocumentAddFromEntryDelegate;
	import com.kaltura.net.KalturaCall;

	public class DocumentAddFromEntry extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param sourceEntryId String
		 * @param documentEntry KalturaDocumentEntry
		 * @param sourceFlavorParamsId int
		 **/
		public function DocumentAddFromEntry( sourceEntryId : String,documentEntry : KalturaDocumentEntry=null,sourceFlavorParamsId : int=undefined )
		{
			service= 'document';
			action= 'addFromEntry';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('sourceEntryId');
			valueArr.push(sourceEntryId);
 			if (documentEntry) { 
 			keyValArr = kalturaObject2Arrays(documentEntry, 'documentEntry');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			} 
			keyArr.push('sourceFlavorParamsId');
			valueArr.push(sourceFlavorParamsId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DocumentAddFromEntryDelegate( this , config );
		}
	}
}
