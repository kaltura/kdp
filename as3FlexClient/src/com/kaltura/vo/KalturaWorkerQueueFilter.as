package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBatchJobFilter;

	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaWorkerQueueFilter extends BaseFlexVo
	{
		public var schedulerId : int = int.MIN_VALUE;
		public var workerId : int = int.MIN_VALUE;
		public var jobType : int = int.MIN_VALUE;
		public var filter : KalturaBatchJobFilter;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('schedulerId');
			propertyList.push('workerId');
			propertyList.push('jobType');
			propertyList.push('filter');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('schedulerId');
			arr.push('workerId');
			arr.push('jobType');
			arr.push('filter');
			return arr;
		}

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('schedulerId');
			arr.push('workerId');
			arr.push('jobType');
			arr.push('filter');
			return arr;
		}

	}
}
