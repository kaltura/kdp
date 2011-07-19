package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaCategory extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;

		public var parentId : int = int.MIN_VALUE;

		public var depth : int = int.MIN_VALUE;

		public var partnerId : int = int.MIN_VALUE;

		public var name : String;

		public var fullName : String;

		public var entriesCount : int = int.MIN_VALUE;

		public var createdAt : int = int.MIN_VALUE;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('parentId');
			arr.push('name');
			return arr;
		}
	}
}
