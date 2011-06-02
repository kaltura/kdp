package com.kaltura.commands.documents
{
	import com.kaltura.delegates.documents.DocumentsConvertPptToSwfDelegate;
	import com.kaltura.net.KalturaCall;

	public class DocumentsConvertPptToSwf extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 **/
		public function DocumentsConvertPptToSwf( entryId : String )
		{
			service= 'document_documents';
			action= 'convertPptToSwf';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DocumentsConvertPptToSwfDelegate( this , config );
		}
	}
}
