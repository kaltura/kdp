package com.kaltura.commands.virusScanBatch
{
	import com.kaltura.vo.KalturaExclusiveLockKey;
	import com.kaltura.delegates.virusScanBatch.VirusScanBatchFreeExclusiveJobDelegate;
	import com.kaltura.net.KalturaCall;

	public class VirusScanBatchFreeExclusiveJob extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param lockKey KalturaExclusiveLockKey
		 * @param jobType String
		 * @param resetExecutionAttempts Boolean
		 **/
		public function VirusScanBatchFreeExclusiveJob( id : int,lockKey : KalturaExclusiveLockKey,jobType : String,resetExecutionAttempts : Boolean=false )
		{
			service= 'virusscan_virusscanbatch';
			action= 'freeExclusiveJob';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(lockKey, 'lockKey');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('jobType');
			valueArr.push(jobType);
			keyArr.push('resetExecutionAttempts');
			valueArr.push(resetExecutionAttempts);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new VirusScanBatchFreeExclusiveJobDelegate( this , config );
		}
	}
}
