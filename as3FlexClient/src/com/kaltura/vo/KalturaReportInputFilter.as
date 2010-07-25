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
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('fromDate');
			propertyList.push('toDate');
			propertyList.push('keywords');
			propertyList.push('searchInTags');
			propertyList.push('searchInAdminTags');
			propertyList.push('categories');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('fromDate');
			arr.push('toDate');
			arr.push('keywords');
			arr.push('searchInTags');
			arr.push('searchInAdminTags');
			arr.push('categories');
			return arr;
		}

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
			return arr;
		}

	}
}
