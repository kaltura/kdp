package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaUploadResponse extends BaseFlexVo
	{
		public var uploadTokenId : String;

		public var fileSize : int = int.MIN_VALUE;

		public var errorCode : int = int.MIN_VALUE;

		public var errorDescription : String;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('uploadTokenId');
			arr.push('fileSize');
			arr.push('errorCode');
			arr.push('errorDescription');
			return arr;
		}
	}
}
