package com.kaltura.vo
{
	import com.kaltura.vo.KalturaJobData;

	import com.kaltura.vo.KalturaBaseJob;

	[Bindable]
	public dynamic class KalturaBatchJob extends KalturaBaseJob
	{
		public var entryId : String;
		public var entryName : String;
		public var jobType : int = int.MIN_VALUE;
		public var jobSubType : int = int.MIN_VALUE;
		public var onStressDivertTo : int = int.MIN_VALUE;
		public var data : KalturaJobData;
		public var status : int = int.MIN_VALUE;
		public var abort : int = int.MIN_VALUE;
		public var checkAgainTimeout : int = int.MIN_VALUE;
		public var progress : int = int.MIN_VALUE;
		public var message : String;
		public var description : String;
		public var updatesCount : int = int.MIN_VALUE;
		public var priority : int = int.MIN_VALUE;
		public var workGroupId : int = int.MIN_VALUE;
		public var twinJobId : int = int.MIN_VALUE;
		public var bulkJobId : int = int.MIN_VALUE;
		public var parentJobId : int = int.MIN_VALUE;
		public var rootJobId : int = int.MIN_VALUE;
		public var queueTime : int = int.MIN_VALUE;
		public var finishTime : int = int.MIN_VALUE;
		public var errType : int = int.MIN_VALUE;
		public var errNumber : int = int.MIN_VALUE;
		public var fileSize : int = int.MIN_VALUE;
		public var lastWorkerRemote : Boolean;
		public var schedulerId : int = int.MIN_VALUE;
		public var workerId : int = int.MIN_VALUE;
		public var batchIndex : int = int.MIN_VALUE;
		public var lastSchedulerId : int = int.MIN_VALUE;
		public var lastWorkerId : int = int.MIN_VALUE;
		public var dc : int = int.MIN_VALUE;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('entryId');
			propertyList.push('entryName');
			propertyList.push('jobType');
			propertyList.push('jobSubType');
			propertyList.push('onStressDivertTo');
			propertyList.push('data');
			propertyList.push('status');
			propertyList.push('abort');
			propertyList.push('checkAgainTimeout');
			propertyList.push('progress');
			propertyList.push('message');
			propertyList.push('description');
			propertyList.push('updatesCount');
			propertyList.push('priority');
			propertyList.push('workGroupId');
			propertyList.push('twinJobId');
			propertyList.push('bulkJobId');
			propertyList.push('parentJobId');
			propertyList.push('rootJobId');
			propertyList.push('queueTime');
			propertyList.push('finishTime');
			propertyList.push('errType');
			propertyList.push('errNumber');
			propertyList.push('fileSize');
			propertyList.push('lastWorkerRemote');
			propertyList.push('schedulerId');
			propertyList.push('workerId');
			propertyList.push('batchIndex');
			propertyList.push('lastSchedulerId');
			propertyList.push('lastWorkerId');
			propertyList.push('dc');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('entryId');
			arr.push('entryName');
			arr.push('jobType');
			arr.push('jobSubType');
			arr.push('onStressDivertTo');
			arr.push('data');
			arr.push('status');
			arr.push('abort');
			arr.push('checkAgainTimeout');
			arr.push('progress');
			arr.push('message');
			arr.push('description');
			arr.push('updatesCount');
			arr.push('priority');
			arr.push('workGroupId');
			arr.push('twinJobId');
			arr.push('bulkJobId');
			arr.push('parentJobId');
			arr.push('rootJobId');
			arr.push('queueTime');
			arr.push('finishTime');
			arr.push('errType');
			arr.push('errNumber');
			arr.push('fileSize');
			arr.push('lastWorkerRemote');
			arr.push('schedulerId');
			arr.push('workerId');
			arr.push('batchIndex');
			arr.push('lastSchedulerId');
			arr.push('lastWorkerId');
			arr.push('dc');
			return arr;
		}

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('entryId');
			arr.push('entryName');
			arr.push('jobSubType');
			arr.push('onStressDivertTo');
			arr.push('data');
			arr.push('status');
			arr.push('abort');
			arr.push('checkAgainTimeout');
			arr.push('progress');
			arr.push('message');
			arr.push('description');
			arr.push('updatesCount');
			arr.push('priority');
			arr.push('workGroupId');
			arr.push('twinJobId');
			arr.push('bulkJobId');
			arr.push('parentJobId');
			arr.push('rootJobId');
			arr.push('queueTime');
			arr.push('finishTime');
			arr.push('errType');
			arr.push('errNumber');
			arr.push('fileSize');
			arr.push('lastWorkerRemote');
			arr.push('schedulerId');
			arr.push('workerId');
			arr.push('batchIndex');
			arr.push('lastSchedulerId');
			arr.push('lastWorkerId');
			arr.push('dc');
			return arr;
		}

	}
}
