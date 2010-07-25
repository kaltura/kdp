package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaUploadToken extends BaseFlexVo
	{
		public var id : String;
		public var partnerId : int = int.MIN_VALUE;
		public var userId : String;
		public var status : int = int.MIN_VALUE;
		public var fileName : String;
		public var fileSize : Number = NaN;
		public var uploadedFileSize : Number = NaN;
		public var createdAt : int = int.MIN_VALUE;
		public var updatedAt : int = int.MIN_VALUE;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('id');
			propertyList.push('partnerId');
			propertyList.push('userId');
			propertyList.push('status');
			propertyList.push('fileName');
			propertyList.push('fileSize');
			propertyList.push('uploadedFileSize');
			propertyList.push('createdAt');
			propertyList.push('updatedAt');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('id');
			arr.push('partnerId');
			arr.push('userId');
			arr.push('status');
			arr.push('fileName');
			arr.push('fileSize');
			arr.push('uploadedFileSize');
			arr.push('createdAt');
			arr.push('updatedAt');
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
