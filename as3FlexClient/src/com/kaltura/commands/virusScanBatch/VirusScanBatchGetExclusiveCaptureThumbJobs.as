package com.kaltura.commands.virusScanBatch
{
	import com.kaltura.vo.KalturaExclusiveLockKey;
	import com.kaltura.vo.KalturaBatchJobFilter;
	import com.kaltura.delegates.virusScanBatch.VirusScanBatchGetExclusiveCaptureThumbJobsDelegate;
	import com.kaltura.net.KalturaCall;

	public class VirusScanBatchGetExclusiveCaptureThumbJobs extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param lockKey KalturaExclusiveLockKey
		 * @param maxExecutionTime int
		 * @param numberOfJobs int
		 * @param filter KalturaBatchJobFilter
		 **/
		public function VirusScanBatchGetExclusiveCaptureThumbJobs( lockKey : KalturaExclusiveLockKey,maxExecutionTime : int,numberOfJobs : int,filter : KalturaBatchJobFilter=null )
		{
			if(filter== null)filter= new KalturaBatchJobFilter();
			service= 'virusscan_virusscanbatch';
			action= 'getExclusiveCaptureThumbJobs';

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
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new VirusScanBatchGetExclusiveCaptureThumbJobsDelegate( this , config );
		}
	}
}
