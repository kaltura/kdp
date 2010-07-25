package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaMetadata extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;
		public var partnerId : int = int.MIN_VALUE;
		public var metadataProfileId : int = int.MIN_VALUE;
		public var metadataProfileVersion : int = int.MIN_VALUE;
		public var metadataObjectType : int = int.MIN_VALUE;
		public var objectId : String;
		public var version : int = int.MIN_VALUE;
		public var createdAt : int = int.MIN_VALUE;
		public var updatedAt : int = int.MIN_VALUE;
		public var status : int = int.MIN_VALUE;
		public var xml : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('id');
			propertyList.push('partnerId');
			propertyList.push('metadataProfileId');
			propertyList.push('metadataProfileVersion');
			propertyList.push('metadataObjectType');
			propertyList.push('objectId');
			propertyList.push('version');
			propertyList.push('createdAt');
			propertyList.push('updatedAt');
			propertyList.push('status');
			propertyList.push('xml');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('id');
			arr.push('partnerId');
			arr.push('metadataProfileId');
			arr.push('metadataProfileVersion');
			arr.push('metadataObjectType');
			arr.push('objectId');
			arr.push('version');
			arr.push('createdAt');
			arr.push('updatedAt');
			arr.push('status');
			arr.push('xml');
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
