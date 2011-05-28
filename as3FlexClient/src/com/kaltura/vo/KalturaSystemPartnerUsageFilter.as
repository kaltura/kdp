package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaSystemPartnerUsageFilter extends KalturaFilter
	{
		public var fromDate : int = int.MIN_VALUE;

		public var toDate : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('fromDate');
			arr.push('toDate');
			return arr;
		}
	}
}
