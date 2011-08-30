package com.kaltura.commands.contentDistributionBatch
{
	import com.kaltura.delegates.contentDistributionBatch.ContentDistributionBatchCreateRequiredJobsDelegate;
	import com.kaltura.net.KalturaCall;

	public class ContentDistributionBatchCreateRequiredJobs extends KalturaCall
	{
		public var filterFields : String;
		/**
		 **/
		public function ContentDistributionBatchCreateRequiredJobs(  )
		{
			service= 'contentdistribution_contentdistributionbatch';
			action= 'createRequiredJobs';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ContentDistributionBatchCreateRequiredJobsDelegate( this , config );
		}
	}
}
