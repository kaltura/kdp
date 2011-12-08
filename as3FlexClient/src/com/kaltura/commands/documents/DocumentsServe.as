package com.kaltura.commands.documents
{
	import com.kaltura.delegates.documents.DocumentsServeDelegate;
	import com.kaltura.net.KalturaCall;

	public class DocumentsServe extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param flavorAssetId String
		 * @param forceProxy Boolean
		 **/
		public function DocumentsServe( entryId : String,flavorAssetId : String = null,forceProxy : Boolean=false )
		{
			service= 'document_documents';
			action= 'serve';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			keyArr.push('flavorAssetId');
			valueArr.push(flavorAssetId);
			keyArr.push('forceProxy');
			valueArr.push(forceProxy);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DocumentsServeDelegate( this , config );
		}
	}
}
