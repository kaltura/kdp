package com.kaltura.commands.virusScanBatch
{
	import com.kaltura.delegates.virusScanBatch.VirusScanBatchLogConversionDelegate;
	import com.kaltura.net.KalturaCall;

	public class VirusScanBatchLogConversion extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param flavorAssetId String
		 * @param data String
		 **/
		public function VirusScanBatchLogConversion( flavorAssetId : String,data : String )
		{
			service= 'virusscan_virusscanbatch';
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
			delegate = new VirusScanBatchLogConversionDelegate( this , config );
		}
	}
}
