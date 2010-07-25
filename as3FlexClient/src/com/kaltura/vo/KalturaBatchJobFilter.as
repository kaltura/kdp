package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseJobFilter;

	[Bindable]
	public dynamic class KalturaBatchJobFilter extends KalturaBaseJobFilter
	{
		public var entryIdEqual : String;
		public var jobTypeEqual : int = int.MIN_VALUE;
		public var jobTypeIn : String;
		public var jobTypeNotIn : int = int.MIN_VALUE;
		public var jobSubTypeEqual : int = int.MIN_VALUE;
		public var jobSubTypeIn : String;
		public var onStressDivertToIn : String;
		public var statusEqual : int = int.MIN_VALUE;
		public var statusIn : String;
		public var priorityGreaterThanOrEqual : int = int.MIN_VALUE;
		public var priorityLessThanOrEqual : int = int.MIN_VALUE;
		public var workGroupIdIn : String;
		public var queueTimeGreaterThanOrEqual : int = int.MIN_VALUE;
		public var queueTimeLessThanOrEqual : int = int.MIN_VALUE;
		public var finishTimeGreaterThanOrEqual : int = int.MIN_VALUE;
		public var finishTimeLessThanOrEqual : int = int.MIN_VALUE;
		public var errTypeIn : String;
		public var fileSizeLessThan : int = int.MIN_VALUE;
		public var fileSizeGreaterThan : int = int.MIN_VALUE;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('entryIdEqual');
			propertyList.push('jobTypeEqual');
			propertyList.push('jobTypeIn');
			propertyList.push('jobTypeNotIn');
			propertyList.push('jobSubTypeEqual');
			propertyList.push('jobSubTypeIn');
			propertyList.push('onStressDivertToIn');
			propertyList.push('statusEqual');
			propertyList.push('statusIn');
			propertyList.push('priorityGreaterThanOrEqual');
			propertyList.push('priorityLessThanOrEqual');
			propertyList.push('workGroupIdIn');
			propertyList.push('queueTimeGreaterThanOrEqual');
			propertyList.push('queueTimeLessThanOrEqual');
			propertyList.push('finishTimeGreaterThanOrEqual');
			propertyList.push('finishTimeLessThanOrEqual');
			propertyList.push('errTypeIn');
			propertyList.push('fileSizeLessThan');
			propertyList.push('fileSizeGreaterThan');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('entryIdEqual');
			arr.push('jobTypeEqual');
			arr.push('jobTypeIn');
			arr.push('jobTypeNotIn');
			arr.push('jobSubTypeEqual');
			arr.push('jobSubTypeIn');
			arr.push('onStressDivertToIn');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('priorityGreaterThanOrEqual');
			arr.push('priorityLessThanOrEqual');
			arr.push('workGroupIdIn');
			arr.push('queueTimeGreaterThanOrEqual');
			arr.push('queueTimeLessThanOrEqual');
			arr.push('finishTimeGreaterThanOrEqual');
			arr.push('finishTimeLessThanOrEqual');
			arr.push('errTypeIn');
			arr.push('fileSizeLessThan');
			arr.push('fileSizeGreaterThan');
			return arr;
		}

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
			arr.push('onStressDivertToIn');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('priorityGreaterThanOrEqual');
			arr.push('priorityLessThanOrEqual');
			arr.push('workGroupIdIn');
			arr.push('queueTimeGreaterThanOrEqual');
			arr.push('queueTimeLessThanOrEqual');
			arr.push('finishTimeGreaterThanOrEqual');
			arr.push('finishTimeLessThanOrEqual');
			arr.push('errTypeIn');
			arr.push('fileSizeLessThan');
			arr.push('fileSizeGreaterThan');
			return arr;
		}

	}
}
