package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaDropFolderFile extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var id : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var dropFolderId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var fileName : String;

		/** 
		* 		* */ 
		public var fileSize : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var fileSizeLastSetAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var status : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var parsedSlug : String;

		/** 
		* 		* */ 
		public var parsedFlavor : String;

		/** 
		* 		* */ 
		public var errorCode : String;

		/** 
		* 		* */ 
		public var errorDescription : String;

		/** 
		* 		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var updatedAt : int = int.MIN_VALUE;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('fileSize');
			arr.push('status');
			arr.push('parsedSlug');
			arr.push('parsedFlavor');
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
			arr.push('dropFolderId');
			arr.push('fileName');
			return arr;
		}

	}
}
