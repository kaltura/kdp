package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaMetadataProfile extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;
		public var partnerId : int = int.MIN_VALUE;
		public var metadataObjectType : int = int.MIN_VALUE;
		public var version : int = int.MIN_VALUE;
		public var name : String;
		public var createdAt : int = int.MIN_VALUE;
		public var updatedAt : int = int.MIN_VALUE;
		public var status : int = int.MIN_VALUE;
		public var xsd : String;
		public var views : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('id');
			propertyList.push('partnerId');
			propertyList.push('metadataObjectType');
			propertyList.push('version');
			propertyList.push('name');
			propertyList.push('createdAt');
			propertyList.push('updatedAt');
			propertyList.push('status');
			propertyList.push('xsd');
			propertyList.push('views');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('id');
			arr.push('partnerId');
			arr.push('metadataObjectType');
			arr.push('version');
			arr.push('name');
			arr.push('createdAt');
			arr.push('updatedAt');
			arr.push('status');
			arr.push('xsd');
			arr.push('views');
			return arr;
		}

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('metadataObjectType');
			arr.push('name');
			return arr;
		}

	}
}
