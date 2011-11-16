package com.kaltura.commands.contentDistributionBatch
{
	import com.kaltura.delegates.contentDistributionBatch.ContentDistributionBatchLogConversionDelegate;
	import com.kaltura.net.KalturaCall;

	public class ContentDistributionBatchLogConversion extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param flavorAssetId String
		 * @param data String
		 **/
		public function ContentDistributionBatchLogConversion( flavorAssetId : String,data : String )
		{
			service= 'contentdistribution_contentdistributionbatch';
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
			delegate = new ContentDistributionBatchLogConversionDelegate( this , config );
		}
	}
}
