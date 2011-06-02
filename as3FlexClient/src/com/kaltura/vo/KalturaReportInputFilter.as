package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaReportInputFilter extends BaseFlexVo
	{
		public var fromDate : int = int.MIN_VALUE;

		public var toDate : int = int.MIN_VALUE;

		public var keywords : String;

		public var searchInTags : Boolean;

		public var searchInAdminTags : Boolean;

		public var categories : String;

		public var timeZoneOffset : int = int.MIN_VALUE;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('fromDate');
			arr.push('toDate');
			arr.push('keywords');
			arr.push('searchInTags');
			arr.push('searchInAdminTags');
			arr.push('categories');
			arr.push('timeZoneOffset');
			return arr;
		}
	}
}
