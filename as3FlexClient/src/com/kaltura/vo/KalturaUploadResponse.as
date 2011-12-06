package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaUploadResponse extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var uploadTokenId : String = null;

		/** 
		* 		* */ 
		public var fileSize : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var errorCode : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var errorDescription : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
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

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		* */ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}

	}
}
