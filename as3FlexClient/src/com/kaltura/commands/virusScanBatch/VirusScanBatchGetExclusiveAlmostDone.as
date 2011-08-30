package com.kaltura.commands.virusScanBatch
{
	import com.kaltura.vo.KalturaExclusiveLockKey;
	import com.kaltura.vo.KalturaBatchJobFilter;
	import com.kaltura.delegates.virusScanBatch.VirusScanBatchGetExclusiveAlmostDoneDelegate;
	import com.kaltura.net.KalturaCall;

	public class VirusScanBatchGetExclusiveAlmostDone extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param lockKey KalturaExclusiveLockKey
		 * @param maxExecutionTime int
		 * @param numberOfJobs int
		 * @param filter KalturaBatchJobFilter
		 * @param jobType String
		 **/
		public function VirusScanBatchGetExclusiveAlmostDone( lockKey : KalturaExclusiveLockKey,maxExecutionTime : int,numberOfJobs : int,filter : KalturaBatchJobFilter=null,jobType : String='null' )
		{
			if(filter== null)filter= new KalturaBatchJobFilter();
			service= 'virusscan_virusscanbatch';
			action= 'getExclusiveAlmostDone';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(lockKey, 'lockKey');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('maxExecutionTime');
			valueArr.push(maxExecutionTime);
			keyArr.push('numberOfJobs');
			valueArr.push(numberOfJobs);
 			keyValArr = kalturaObject2Arrays(filter, 'filter');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('jobType');
			valueArr.push(jobType);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new VirusScanBatchGetExclusiveAlmostDoneDelegate( this , config );
		}
	}
}
