package com.kaltura.commands.metadataBatch
{
	import com.kaltura.delegates.metadataBatch.MetadataBatchGetBulkUploadLastResultDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataBatchGetBulkUploadLastResult extends KalturaCall
	{
		public var filterFields : String;
		public function MetadataBatchGetBulkUploadLastResult( bulkUploadJobId : int )
		{
			service= 'metadata_metadatabatch';
			action= 'getBulkUploadLastResult';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'bulkUploadJobId' );
			valueArr.push( bulkUploadJobId );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new MetadataBatchGetBulkUploadLastResultDelegate( this , config );
		}
	}
}
