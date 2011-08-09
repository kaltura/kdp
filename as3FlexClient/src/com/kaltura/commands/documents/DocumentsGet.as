package com.kaltura.commands.documents
{
	import com.kaltura.delegates.documents.DocumentsGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class DocumentsGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param version int
		 **/
		public function DocumentsGet( entryId : String,version : int=-1 )
		{
			service= 'document_documents';
			action= 'get';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			keyArr.push('version');
			valueArr.push(version);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DocumentsGetDelegate( this , config );
		}
	}
}
