package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaBatchGetExclusiveNotificationJobsResponse extends BaseFlexVo
	{
		public var notifications : Array = new Array();

		public var partners : Array = new Array();

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}
	}
}
