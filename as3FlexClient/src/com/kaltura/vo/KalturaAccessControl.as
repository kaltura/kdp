package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaAccessControl extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;
		public var partnerId : int = int.MIN_VALUE;
		public var name : String;
		public var description : String;
		public var createdAt : int = int.MIN_VALUE;
		public var isDefault : int = int.MIN_VALUE;
		public var restrictions : Array = new Array();
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('id');
			propertyList.push('partnerId');
			propertyList.push('name');
			propertyList.push('description');
			propertyList.push('createdAt');
			propertyList.push('isDefault');
			propertyList.push('restrictions');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('id');
			arr.push('partnerId');
			arr.push('name');
			arr.push('description');
			arr.push('createdAt');
			arr.push('isDefault');
			arr.push('restrictions');
			return arr;
		}

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('description');
			arr.push('isDefault');
			arr.push('restrictions');
			return arr;
		}

	}
}
