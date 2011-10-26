package com.kaltura.commands.filesyncImportBatch
{
	import com.kaltura.delegates.filesyncImportBatch.FilesyncImportBatchLogConversionDelegate;
	import com.kaltura.net.KalturaCall;

	public class FilesyncImportBatchLogConversion extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param flavorAssetId String
		 * @param data String
		 **/
		public function FilesyncImportBatchLogConversion( flavorAssetId : String,data : String )
		{
			service= 'multicenters_filesyncimportbatch';
			action= 'logConversion';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('flavorAssetId');
			valueArr.push(flavorAssetId);
			keyArr.push('data');
			valueArr.push(data);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new FilesyncImportBatchLogConversionDelegate( this , config );
		}
	}
}
