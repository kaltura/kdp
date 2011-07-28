package com.kaltura.commands.virusScanBatch
{
	import com.kaltura.vo.KalturaWorkerQueueFilter;
	import com.kaltura.delegates.virusScanBatch.VirusScanBatchGetQueueSizeDelegate;
	import com.kaltura.net.KalturaCall;

	public class VirusScanBatchGetQueueSize extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param workerQueueFilter KalturaWorkerQueueFilter
		 **/
		public function VirusScanBatchGetQueueSize( workerQueueFilter : KalturaWorkerQueueFilter )
		{
			service= 'virusscan_virusscanbatch';
			action= 'getQueueSize';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(workerQueueFilter, 'workerQueueFilter');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new VirusScanBatchGetQueueSizeDelegate( this , config );
		}
	}
}
