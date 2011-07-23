package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaUploadToken extends BaseFlexVo
	{
		/** 
		* Upload token unique ID		* */ 
		public var id : String;

		/** 
		* Partner ID of the upload token		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* User id for the upload token		* */ 
		public var userId : String;

		/** 
		* Status of the upload token		* */ 
		public var status : int = int.MIN_VALUE;

		/** 
		* Name of the file for the upload token, can be empty when the upload token is created and will be updated internally after the file is uploaded		* */ 
		public var fileName : String;

		/** 
		* File size in bytes, can be empty when the upload token is created and will be updated internally after the file is uploaded		* */ 
		public var fileSize : Number = NaN;

		/** 
		* Uploaded file size in bytes, can be used to identify how many bytes were uploaded before resuming		* */ 
		public var uploadedFileSize : Number = NaN;

		/** 
		* Creation date as Unix timestamp (In seconds)		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* Last update date as Unix timestamp (In seconds)		* */ 
		public var updatedAt : int = int.MIN_VALUE;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		* */ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('fileName');
			arr.push('fileSize');
			return arr;
		}

	}
}
