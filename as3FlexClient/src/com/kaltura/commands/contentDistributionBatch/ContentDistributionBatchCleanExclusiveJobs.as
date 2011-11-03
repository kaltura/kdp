package com.kaltura.commands.contentDistributionBatch
{
	import com.kaltura.delegates.contentDistributionBatch.ContentDistributionBatchCleanExclusiveJobsDelegate;
	import com.kaltura.net.KalturaCall;

	public class ContentDistributionBatchCleanExclusiveJobs extends KalturaCall
	{
		public var filterFields : String;
		/**
		 **/
		public function ContentDistributionBatchCleanExclusiveJobs(  )
		{
			service= 'contentdistribution_contentdistributionbatch';
			action= 'cleanExclusiveJobs';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ContentDistributionBatchCleanExclusiveJobsDelegate( this , config );
		}
	}
}
