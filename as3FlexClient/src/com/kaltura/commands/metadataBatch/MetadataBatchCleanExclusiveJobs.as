package com.kaltura.commands.metadataBatch
{
	import com.kaltura.delegates.metadataBatch.MetadataBatchCleanExclusiveJobsDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataBatchCleanExclusiveJobs extends KalturaCall
	{
		public var filterFields : String;
		public function MetadataBatchCleanExclusiveJobs(  )
		{
			service= 'metadata_metadatabatch';
			action= 'cleanExclusiveJobs';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new MetadataBatchCleanExclusiveJobsDelegate( this , config );
		}
	}
}
