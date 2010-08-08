package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaBaseJob extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;
		public var partnerId : int = int.MIN_VALUE;
		public var createdAt : int = int.MIN_VALUE;
		public var updatedAt : int = int.MIN_VALUE;
		public var deletedAt : int = int.MIN_VALUE;
		public var processorExpiration : int = int.MIN_VALUE;
		public var executionAttempts : int = int.MIN_VALUE;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('id');
			propertyList.push('partnerId');
			propertyList.push('createdAt');
			propertyList.push('updatedAt');
			propertyList.push('deletedAt');
			propertyList.push('processorExpiration');
			propertyList.push('executionAttempts');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('id');
			arr.push('partnerId');
			arr.push('createdAt');
			arr.push('updatedAt');
			arr.push('deletedAt');
			arr.push('processorExpiration');
			arr.push('executionAttempts');
			return arr;
		}

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}

	}
}
