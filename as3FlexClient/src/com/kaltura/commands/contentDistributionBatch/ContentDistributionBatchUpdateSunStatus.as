package com.kaltura.commands.contentDistributionBatch
{
	import com.kaltura.delegates.contentDistributionBatch.ContentDistributionBatchUpdateSunStatusDelegate;
	import com.kaltura.net.KalturaCall;

	public class ContentDistributionBatchUpdateSunStatus extends KalturaCall
	{
		public var filterFields : String;
		/**
		 **/
		public function ContentDistributionBatchUpdateSunStatus(  )
		{
			service= 'contentdistribution_contentdistributionbatch';
			action= 'updateSunStatus';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ContentDistributionBatchUpdateSunStatusDelegate( this , config );
		}
	}
}
