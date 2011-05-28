package com.kaltura.commands.virusScanBatch
{
	import com.kaltura.delegates.virusScanBatch.VirusScanBatchCleanExclusiveJobsDelegate;
	import com.kaltura.net.KalturaCall;

	public class VirusScanBatchCleanExclusiveJobs extends KalturaCall
	{
		public var filterFields : String;
		/**
		 **/
		public function VirusScanBatchCleanExclusiveJobs(  )
		{
			service= 'virusscan_virusscanbatch';
			action= 'cleanExclusiveJobs';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new VirusScanBatchCleanExclusiveJobsDelegate( this , config );
		}
	}
}
