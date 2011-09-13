package com.kaltura.commands.contentDistributionBatch
{
	import com.kaltura.vo.KalturaExclusiveLockKey;
	import com.kaltura.delegates.contentDistributionBatch.ContentDistributionBatchFreeExclusiveConvertJobDelegate;
	import com.kaltura.net.KalturaCall;

	public class ContentDistributionBatchFreeExclusiveConvertJob extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param lockKey KalturaExclusiveLockKey
		 * @param resetExecutionAttempts Boolean
		 **/
		public function ContentDistributionBatchFreeExclusiveConvertJob( id : int,lockKey : KalturaExclusiveLockKey,resetExecutionAttempts : Boolean=false )
		{
			service= 'contentdistribution_contentdistributionbatch';
			action= 'freeExclusiveConvertJob';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(lockKey, 'lockKey');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('resetExecutionAttempts');
			valueArr.push(resetExecutionAttempts);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ContentDistributionBatchFreeExclusiveConvertJobDelegate( this , config );
		}
	}
}
