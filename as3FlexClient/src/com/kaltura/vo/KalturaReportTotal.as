package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaReportTotal extends BaseFlexVo
	{
		public var header : String;

		public var data : String;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('header');
			arr.push('data');
			return arr;
		}
	}
}
