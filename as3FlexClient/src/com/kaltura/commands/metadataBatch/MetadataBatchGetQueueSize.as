package com.kaltura.commands.metadataBatch
{
	import com.kaltura.vo.KalturaWorkerQueueFilter;
	import com.kaltura.delegates.metadataBatch.MetadataBatchGetQueueSizeDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataBatchGetQueueSize extends KalturaCall
	{
		public var filterFields : String;
		public function MetadataBatchGetQueueSize( workerQueueFilter : KalturaWorkerQueueFilter )
		{
			service= 'metadata_metadatabatch';
			action= 'getQueueSize';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(workerQueueFilter,'workerQueueFilter');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new MetadataBatchGetQueueSizeDelegate( this , config );
		}
	}
}
