package com.kaltura.commands.documents
{
	import com.kaltura.delegates.documents.DocumentsServeByFlavorParamsIdDelegate;
	import com.kaltura.net.KalturaCall;

	public class DocumentsServeByFlavorParamsId extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param flavorParamsId String
		 * @param forceProxy Boolean
		 **/
		public function DocumentsServeByFlavorParamsId( entryId : String,flavorParamsId : String = null,forceProxy : Boolean=false )
		{
			service= 'document_documents';
			action= 'serveByFlavorParamsId';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			keyArr.push('flavorParamsId');
			valueArr.push(flavorParamsId);
			keyArr.push('forceProxy');
			valueArr.push(forceProxy);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DocumentsServeByFlavorParamsIdDelegate( this , config );
		}
	}
}
