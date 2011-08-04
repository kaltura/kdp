package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaBulkUpload extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var id : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var uploadedBy : String;

		/** 
		* 		* */ 
		public var uploadedByUserId : String;

		/** 
		* 		* */ 
		public var uploadedOn : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var numOfEntries : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var status : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var logFileUrl : String;

		/** 
		* DEPRECATED		* */ 
		public var csvFileUrl : String;

		/** 
		* 		* */ 
		public var bulkFileUrl : String;

		/** 
		* 		* */ 
		public var bulkUploadType : String;

		/** 
		* 		* */ 
		public var results : Array = new Array();

		/** 
		* 		* */ 
		public var error : String;

		/** 
		* 		* */ 
		public var errorType : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var errorNumber : int = int.MIN_VALUE;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('id');
			arr.push('uploadedBy');
			arr.push('uploadedByUserId');
			arr.push('uploadedOn');
			arr.push('numOfEntries');
			arr.push('status');
			arr.push('logFileUrl');
			arr.push('csvFileUrl');
			arr.push('bulkFileUrl');
			arr.push('bulkUploadType');
			arr.push('results');
			arr.push('error');
			arr.push('errorType');
			arr.push('errorNumber');
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
