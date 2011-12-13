package com.kaltura.commands.metadataBatch
{
	import com.kaltura.vo.KalturaBulkUploadResult;
	import com.kaltura.delegates.metadataBatch.MetadataBatchAddBulkUploadResultDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataBatchAddBulkUploadResult extends KalturaCall
	{
		public var filterFields : String;
		public function MetadataBatchAddBulkUploadResult( bulkUploadResult : KalturaBulkUploadResult,pluginDataArray : Array=null )
		{
			if(pluginDataArray== null)pluginDataArray= new Array();
			service= 'metadata_metadatabatch';
			action= 'addBulkUploadResult';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(bulkUploadResult,'bulkUploadResult');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
 			keyValArr = extractArray(pluginDataArray,'pluginDataArray');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new MetadataBatchAddBulkUploadResultDelegate( this , config );
		}
	}
}
