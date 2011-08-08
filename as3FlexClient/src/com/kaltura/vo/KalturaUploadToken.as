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

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}
	}
}
