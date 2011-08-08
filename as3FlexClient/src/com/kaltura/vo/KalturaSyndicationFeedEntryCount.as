package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaSyndicationFeedEntryCount extends BaseFlexVo
	{
		public var totalEntryCount : int = int.MIN_VALUE;

		public var actualEntryCount : int = int.MIN_VALUE;

		public var requireTranscodingCount : int = int.MIN_VALUE;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('totalEntryCount');
			arr.push('actualEntryCount');
			arr.push('requireTranscodingCount');
			return arr;
		}
	}
}
