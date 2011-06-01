package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaFilterPager extends BaseFlexVo
	{
		public var pageSize : int = int.MIN_VALUE;

		public var pageIndex : int = int.MIN_VALUE;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('pageSize');
			arr.push('pageIndex');
			return arr;
		}
	}
}
