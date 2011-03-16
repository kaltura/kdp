package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaPartnerUsage extends BaseFlexVo
	{
		public var hostingGB : Number = NaN;

		public var Percent : Number = NaN;

		public var packageBW : int = int.MIN_VALUE;

		public var usageGB : int = int.MIN_VALUE;

		public var reachedLimitDate : int = int.MIN_VALUE;

		public var usageGraph : String;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}
	}
}
