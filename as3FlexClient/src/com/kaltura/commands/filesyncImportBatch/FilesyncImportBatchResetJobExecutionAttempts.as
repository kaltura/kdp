package com.kaltura.commands.filesyncImportBatch
{
	import com.kaltura.vo.KalturaExclusiveLockKey;
	import com.kaltura.delegates.filesyncImportBatch.FilesyncImportBatchResetJobExecutionAttemptsDelegate;
	import com.kaltura.net.KalturaCall;

	public class FilesyncImportBatchResetJobExecutionAttempts extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param lockKey KalturaExclusiveLockKey
		 * @param jobType String
		 **/
		public function FilesyncImportBatchResetJobExecutionAttempts( id : int,lockKey : KalturaExclusiveLockKey,jobType : String )
		{
			service= 'multicenters_filesyncimportbatch';
			action= 'resetJobExecutionAttempts';

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
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new FilesyncImportBatchResetJobExecutionAttemptsDelegate( this , config );
		}
	}
}
