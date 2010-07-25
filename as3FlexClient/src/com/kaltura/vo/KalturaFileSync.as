package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaFileSync extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;
		public var partnerId : int = int.MIN_VALUE;
		public var objectType : int = int.MIN_VALUE;
		public var objectId : String;
		public var version : String;
		public var objectSubType : int = int.MIN_VALUE;
		public var dc : String;
		public var original : int = int.MIN_VALUE;
		public var createdAt : int = int.MIN_VALUE;
		public var updatedAt : int = int.MIN_VALUE;
		public var readyAt : int = int.MIN_VALUE;
		public var syncTime : int = int.MIN_VALUE;
		public var status : int = int.MIN_VALUE;
		public var fileType : int = int.MIN_VALUE;
		public var linkedId : int = int.MIN_VALUE;
		public var linkCount : int = int.MIN_VALUE;
		public var fileRoot : String;
		public var filePath : String;
		public var fileSize : int = int.MIN_VALUE;
		public var fileUrl : String;
		public var fileContent : String;
		public var fileDiscSize : int = int.MIN_VALUE;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('id');
			propertyList.push('partnerId');
			propertyList.push('objectType');
			propertyList.push('objectId');
			propertyList.push('version');
			propertyList.push('objectSubType');
			propertyList.push('dc');
			propertyList.push('original');
			propertyList.push('createdAt');
			propertyList.push('updatedAt');
			propertyList.push('readyAt');
			propertyList.push('syncTime');
			propertyList.push('status');
			propertyList.push('fileType');
			propertyList.push('linkedId');
			propertyList.push('linkCount');
			propertyList.push('fileRoot');
			propertyList.push('filePath');
			propertyList.push('fileSize');
			propertyList.push('fileUrl');
			propertyList.push('fileContent');
			propertyList.push('fileDiscSize');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('id');
			arr.push('partnerId');
			arr.push('objectType');
			arr.push('objectId');
			arr.push('version');
			arr.push('objectSubType');
			arr.push('dc');
			arr.push('original');
			arr.push('createdAt');
			arr.push('updatedAt');
			arr.push('readyAt');
			arr.push('syncTime');
			arr.push('status');
			arr.push('fileType');
			arr.push('linkedId');
			arr.push('linkCount');
			arr.push('fileRoot');
			arr.push('filePath');
			arr.push('fileSize');
			arr.push('fileUrl');
			arr.push('fileContent');
			arr.push('fileDiscSize');
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
