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
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('id');
			propertyList.push('parentId');
			propertyList.push('depth');
			propertyList.push('partnerId');
			propertyList.push('name');
			propertyList.push('fullName');
			propertyList.push('entriesCount');
			propertyList.push('createdAt');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('id');
			arr.push('parentId');
			arr.push('depth');
			arr.push('partnerId');
			arr.push('name');
			arr.push('fullName');
			arr.push('entriesCount');
			arr.push('createdAt');
			return arr;
		}

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
