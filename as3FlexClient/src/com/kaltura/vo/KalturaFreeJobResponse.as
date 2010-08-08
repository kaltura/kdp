package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBatchJob;

	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaFreeJobResponse extends BaseFlexVo
	{
		public var job : KalturaBatchJob;
		public var jobType : int = int.MIN_VALUE;
		public var queueSize : int = int.MIN_VALUE;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('job');
			propertyList.push('jobType');
			propertyList.push('queueSize');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('job');
			arr.push('jobType');
			arr.push('queueSize');
			return arr;
		}

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}

	}
}
