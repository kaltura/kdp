package com.kaltura.commands.filesyncImportBatch
{
	import com.kaltura.delegates.filesyncImportBatch.FilesyncImportBatchCleanExclusiveJobsDelegate;
	import com.kaltura.net.KalturaCall;

	public class FilesyncImportBatchCleanExclusiveJobs extends KalturaCall
	{
		public var filterFields : String;
		/**
		 **/
		public function FilesyncImportBatchCleanExclusiveJobs(  )
		{
			service= 'multicenters_filesyncimportbatch';
			action= 'cleanExclusiveJobs';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new FilesyncImportBatchCleanExclusiveJobsDelegate( this , config );
		}
	}
}
