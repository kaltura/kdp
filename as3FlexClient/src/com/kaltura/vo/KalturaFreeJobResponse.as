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

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}
	}
}
