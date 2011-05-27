package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseJobFilter;

	[Bindable]
	public dynamic class KalturaBatchJobBaseFilter extends KalturaBaseJobFilter
	{
		public var entryIdEqual : String;

		public var jobTypeEqual : String;

		public var jobTypeIn : String;

		public var jobTypeNotIn : String;

		public var jobSubTypeEqual : int = int.MIN_VALUE;

		public var jobSubTypeIn : String;

		public var jobSubTypeNotIn : String;

		public var onStressDivertToEqual : int = int.MIN_VALUE;

		public var onStressDivertToIn : String;

		public var onStressDivertToNotIn : String;

		public var statusEqual : int = int.MIN_VALUE;

		public var statusIn : String;

		public var statusNotIn : String;

		public var abortEqual : int = int.MIN_VALUE;

		public var checkAgainTimeoutGreaterThanOrEqual : int = int.MIN_VALUE;

		public var checkAgainTimeoutLessThanOrEqual : int = int.MIN_VALUE;

		public var progressGreaterThanOrEqual : int = int.MIN_VALUE;

		public var progressLessThanOrEqual : int = int.MIN_VALUE;

		public var updatesCountGreaterThanOrEqual : int = int.MIN_VALUE;

		public var updatesCountLessThanOrEqual : int = int.MIN_VALUE;

		public var priorityGreaterThanOrEqual : int = int.MIN_VALUE;

		public var priorityLessThanOrEqual : int = int.MIN_VALUE;

		public var priorityEqual : int = int.MIN_VALUE;

		public var priorityIn : String;

		public var priorityNotIn : String;

		public var twinJobIdEqual : int = int.MIN_VALUE;

		public var twinJobIdIn : String;

		public var twinJobIdNotIn : String;

		public var bulkJobIdEqual : int = int.MIN_VALUE;

		public var bulkJobIdIn : String;

		public var bulkJobIdNotIn : String;

		public var parentJobIdEqual : int = int.MIN_VALUE;

		public var parentJobIdIn : String;

		public var parentJobIdNotIn : String;

		public var rootJobIdEqual : int = int.MIN_VALUE;

		public var rootJobIdIn : String;

		public var rootJobIdNotIn : String;

		public var queueTimeGreaterThanOrEqual : int = int.MIN_VALUE;

		public var queueTimeLessThanOrEqual : int = int.MIN_VALUE;

		public var finishTimeGreaterThanOrEqual : int = int.MIN_VALUE;

		public var finishTimeLessThanOrEqual : int = int.MIN_VALUE;

		public var errTypeEqual : int = int.MIN_VALUE;

		public var errTypeIn : String;

		public var errTypeNotIn : String;

		public var errNumberEqual : int = int.MIN_VALUE;

		public var errNumberIn : String;

		public var errNumberNotIn : String;

		public var fileSizeLessThan : int = int.MIN_VALUE;

		public var fileSizeGreaterThan : int = int.MIN_VALUE;

		public var lastWorkerRemoteEqual : Boolean;

		public var schedulerIdEqual : int = int.MIN_VALUE;

		public var schedulerIdIn : String;

		public var schedulerIdNotIn : String;

		public var workerIdEqual : int = int.MIN_VALUE;

		public var workerIdIn : String;

		public var workerIdNotIn : String;

		public var batchIndexEqual : int = int.MIN_VALUE;

		public var batchIndexIn : String;

		public var batchIndexNotIn : String;

		public var lastSchedulerIdEqual : int = int.MIN_VALUE;

		public var lastSchedulerIdIn : String;

		public var lastSchedulerIdNotIn : String;

		public var lastWorkerIdEqual : int = int.MIN_VALUE;

		public var lastWorkerIdIn : String;

		public var lastWorkerIdNotIn : String;

		public var dcEqual : int = int.MIN_VALUE;

		public var dcIn : String;

		public var dcNotIn : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('entryIdEqual');
			arr.push('jobTypeEqual');
			arr.push('jobTypeIn');
			arr.push('jobTypeNotIn');
			arr.push('jobSubTypeEqual');
			arr.push('jobSubTypeIn');
			arr.push('jobSubTypeNotIn');
			arr.push('onStressDivertToEqual');
			arr.push('onStressDivertToIn');
			arr.push('onStressDivertToNotIn');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('statusNotIn');
			arr.push('abortEqual');
			arr.push('checkAgainTimeoutGreaterThanOrEqual');
			arr.push('checkAgainTimeoutLessThanOrEqual');
			arr.push('progressGreaterThanOrEqual');
			arr.push('progressLessThanOrEqual');
			arr.push('updatesCountGreaterThanOrEqual');
			arr.push('updatesCountLessThanOrEqual');
			arr.push('priorityGreaterThanOrEqual');
			arr.push('priorityLessThanOrEqual');
			arr.push('priorityEqual');
			arr.push('priorityIn');
			arr.push('priorityNotIn');
			arr.push('twinJobIdEqual');
			arr.push('twinJobIdIn');
			arr.push('twinJobIdNotIn');
			arr.push('bulkJobIdEqual');
			arr.push('bulkJobIdIn');
			arr.push('bulkJobIdNotIn');
			arr.push('parentJobIdEqual');
			arr.push('parentJobIdIn');
			arr.push('parentJobIdNotIn');
			arr.push('rootJobIdEqual');
			arr.push('rootJobIdIn');
			arr.push('rootJobIdNotIn');
			arr.push('queueTimeGreaterThanOrEqual');
			arr.push('queueTimeLessThanOrEqual');
			arr.push('finishTimeGreaterThanOrEqual');
			arr.push('finishTimeLessThanOrEqual');
			arr.push('errTypeEqual');
			arr.push('errTypeIn');
			arr.push('errTypeNotIn');
			arr.push('errNumberEqual');
			arr.push('errNumberIn');
			arr.push('errNumberNotIn');
			arr.push('fileSizeLessThan');
			arr.push('fileSizeGreaterThan');
			arr.push('lastWorkerRemoteEqual');
			arr.push('schedulerIdEqual');
			arr.push('schedulerIdIn');
			arr.push('schedulerIdNotIn');
			arr.push('workerIdEqual');
			arr.push('workerIdIn');
			arr.push('workerIdNotIn');
			arr.push('batchIndexEqual');
			arr.push('batchIndexIn');
			arr.push('batchIndexNotIn');
			arr.push('lastSchedulerIdEqual');
			arr.push('lastSchedulerIdIn');
			arr.push('lastSchedulerIdNotIn');
			arr.push('lastWorkerIdEqual');
			arr.push('lastWorkerIdIn');
			arr.push('lastWorkerIdNotIn');
			arr.push('dcEqual');
			arr.push('dcIn');
			arr.push('dcNotIn');
			return arr;
		}
	}
}
